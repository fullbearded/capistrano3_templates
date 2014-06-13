require "capistrano3_templates/version"
require 'rails/generators'

module Capistrano3Templates
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Generates a custom capistrano 3 template"

      def self.source_root
        @_rails_config_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer
        template "Capfile", "Capfile"
      end

      def copy_settings
        directory 'config', 'config'
        directory 'lib', 'lib'
      end

    end    
  end
end
