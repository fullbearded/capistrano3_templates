# monit opertaion
namespace :sidekiq do
  %w(start stop).each do |task_name|
    desc "#{task_name} Sidekiq"
    task task_name do
      on roles(:app), in: :sequence, wait: 5 do
        execute "service sidekiq #{task_name}"
      end
    end
  end

  desc "restart Sidekiq"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "service sidekiq stop"
      execute "service sidekiq start"
    end
  end

end