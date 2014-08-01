lock '3.2.1'

set :application, 'app_name'
set :deploy_user, 'deploy'
set :default_stage, "production"

# setup repo details
set :scm, :git
set :repo_url, 'git@github.com:username/repo.git'

# setup rbenv.
set :rbenv_type, :system
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# how many old releases do we want to keep, not much
set :keep_releases, 5

# files we want symlinking to specific entries in shared
set :linked_files, %w{
  config/database.yml
  config/memcached.yml
  config/settings.local.yml
}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}


# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  database.example.yml
  monit
  unicorn.rb
  unicorn_init.sh
  nginx
  memcached.yml
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
  nginx
))


# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_{{full_app_name}}"
  },
  {
    source: "monit",
    link: "/etc/monit/conf.d/{{full_app_name}}.conf"
  },
  {
    source: 'nginx',
    link: "/etc/init.d/nginx"
  },
  {
    source: 'nginx.conf',
    link: "/usr/local/nginx/conf/conf.d/{{full_app_name}}.conf"
  }
])

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'
  after 'deploy:setup_config', 'monit:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
end

