namespace :deploy do
  desc "compiles assets locally then rsyncs"
  task :compile_assets_locally do

    # local run assets
    run_locally do
      execute "RAILS_ENV=#{fetch(:rails_env)} bundle exec rake assets:precompile"
    end

    # scp to release path
    on roles(:app) do |role|
      run_locally do
        execute"rsync -av ./public/assets/ #{role.user}@#{role.hostname}:#{release_path}/public/assets/;"
      end
    end

    # remove the local assets
    run_locally do
      execute "rm -rf ./public/assets"
    end
  end
end
