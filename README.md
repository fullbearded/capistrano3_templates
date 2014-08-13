# Capistrano3 templates

this is the templates gem for capistrano 3, you can use it for your project to deployment! 

base on 'https://github.com/TalkingQuickly/capistrano-3-rails-template.git'

## Installation

Add this line to your application's Gemfile:
    
    gem 'capistrano3_templates', git: 'https://github.com/huhongda/capistrano3_templates.git'

And then execute:

    $ bundle

## Usage

    rails g capistrano3_templates:install

## optimize unicorn
<pre>
gem 'unicorn-worker-killer'

require 'unicorn/oob_gc'
require 'unicorn/worker_killer'
#每10次请求，才执行一次GC
use Unicorn::OobGC, 5
#设定最大请求次数后自杀，避免禁止GC带来的内存泄漏（3072～4096之间随机，避免同时多个进程同时自杀，可以和下面的设定任选）
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096
#设定达到最大内存后自杀，避免禁止GC带来的内存泄漏（192～256MB之间随机，避免同时多个进程同时自杀）
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2))
</pre>

## Dependency
  
    gem 'capistrano'

## Contributing

1. Fork it ( https://github.com/huhongda/capistrano3-templates/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
