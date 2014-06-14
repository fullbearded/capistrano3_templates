namespace :deploy do
  desc "checks whether the currently checkout out revision matches the
        remote one we're trying to deploy from"
  task :check_revision do
    branch = fetch(:branch)

    if `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "SUCCESS: origin is #{branch}"
    else
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes or make sure you've"
      puts "checked out the branch: #{branch} as you can only deploy"
      puts "if you've got the target branch checked out"
      exit
    end
  end
end
