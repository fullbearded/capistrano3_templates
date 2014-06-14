namespace :deploy do

  # we often want to refer to variables which
  # are defined in subsequent stage files. This
  # let's us use the {{var}} to represent fetch(:var)
  # in strings which are only evaluated at runtime.

  def sub_strings(input_string)
    output_string = input_string
    input_string.scan(/{{(\w*)}}/).each do |var|
      output_string.gsub!("{{#{var[0]}}}", fetch(var[0].to_sym))
    end
    output_string
  end


  # will first try and copy the file:
  # config/deploy/#{full_app_name}/#{from}.erb
  # to:
  # shared/config/to
  # if the original source path doesn exist then it will
  # search in:
  # config/deploy/shared/#{from}.erb
  # this allows files which are common to all enviros to
  # come from a single source while allowing specific
  # ones to be over-ridden
  # if the target file name is the same as the source then
  # the second parameter can be left out
  def smart_template(from, to=nil)
    to ||= from
    full_to_path = "#{shared_path}/config/#{to}"
    if from_erb_path = template_file(from)
      from_erb = StringIO.new(ERB.new(File.read(from_erb_path)).result(binding))
      upload! from_erb, full_to_path
      info "copying: #{from_erb} to: #{full_to_path}"
    else
      error "error #{from} not found"
    end
  end

  def template_file(name)
    if File.exist?((file = "config/deploy/#{fetch(:full_app_name)}/#{name}.erb"))
      return file
    elsif File.exist?((file = "config/deploy/shared/#{name}.erb"))
      return file
    end
    return nil
  end


  task :setup_config do
    on roles(:app) do
      # make the config dir
      execute :mkdir, "-p #{shared_path}/config"
      full_app_name = fetch(:full_app_name)

      # config files to be uploaded to shared/config, see the
      # definition of smart_template for details of operation.
      # Essentially looks for #{filename}.erb in deploy/#{full_app_name}/
      # and if it isn't there, falls back to deploy/#{shared}. Generally
      # everything should be in deploy/shared with params which differ
      # set in the stage files
      config_files = fetch(:config_files)
      config_files.each do |file|
        smart_template file
      end

      # which of the above files should be marked as executable
      executable_files = fetch(:executable_config_files)
      executable_files.each do |file|
        execute :chmod, "+x #{shared_path}/config/#{file}"
      end

      # symlink stuff which should be... symlinked
      symlinks = fetch(:symlinks)

      symlinks.each do |symlink|
        sudo "ln -nfs #{shared_path}/config/#{symlink[:source]} #{sub_strings(symlink[:link])}"
      end
    end
  end
end
