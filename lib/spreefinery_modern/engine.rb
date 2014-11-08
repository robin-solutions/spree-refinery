require 'spree/authentication_helper'

module SpreefineryModern
  class Engine < ::Rails::Engine
    engine_name 'spreefinery_modern'

    initializer "spreefinery.environment", :before => :load_config_initializers do |app|
      SpreefineryModern::Config = Spree::AuthConfiguration.new
    end

    initializer "spreefinery_modern.set_user_class", :after => :load_config_initializers do
      Spree.user_class = "Refinery::User"
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      # if SpreefineryModern::Engine.backend_available?
      #   Dir.glob(File.join(File.dirname(__FILE__), "../../app/controllers/backend/*/*/*_decorator*.rb")) do |c|
      #     Rails.configuration.cache_classes ? require(c) : load(c)
      #   end
      # end
      # if SpreefineryModern::Engine.frontend_available?
      #   Dir.glob(File.join(File.dirname(__FILE__), "../../app/controllers/frontend/*/*_decorator*.rb")) do |c|
      #     Rails.configuration.cache_classes ? require(c) : load(c)
      #   end
      # end
      ApplicationController.send :include, Spree::AuthenticationHelpers
      ApplicationController.send :include, Spree::CurrentUserHelpers

      Spree::Api::BaseController.send :include, Spree::CurrentUserHelpers
    end

    # def self.backend_available?
    #   @@backend_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Backend::Engine')
    # end

    def self.dash_available?
      @@dash_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Dash::Engine')
    end

    # def self.frontend_available?
    #   @@frontend_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Frontend::Engine')
    # end

    paths['app/controllers'] << 'app/controllers/frontend' 
    paths['app/controllers'] << 'app/controllers/backend'
    paths['app/views'] << 'app/views/frontend'
    paths['app/views'] << 'app/views/backend'

    puts "Controllers: #{paths['app/controllers']}\nViews: #{paths['app/views']}"

    config.to_prepare &method(:activate).to_proc
  end
end
