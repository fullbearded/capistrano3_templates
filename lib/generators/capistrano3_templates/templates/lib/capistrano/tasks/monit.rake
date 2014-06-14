# monit opertaion
namespace :monit do
  %w(start stop restart).each do |task_name|
    desc "#{task_name} Monit"
    task task_name do
      on roles(:app), in: :sequence, wait: 5 do
        execute "service monit #{task_name}"
      end
    end
  end
end
