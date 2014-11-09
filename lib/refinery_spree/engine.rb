module RefinerySpree
  class Engine < ::Rails::Engine
    engine_name 'refinery_spree'

    initializer "refinery_spree.environment", :before => :load_config_initializers do |app|
      RefinerySpree::Config = Spree::AuthConfiguration.new
    end

    initializer "refinery_spree_modern.set_user_class", :before => :load_config_initializers do
      Spree.user_class = "Refinery::User"
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      ApplicationController.send :include, Spree::AuthenticationHelpers
      ApplicationController.send :include, Spree::CurrentUserHelpers
      Spree::Api::BaseController.send :include, Spree::CurrentUserHelpers
    end

    def self.dash_available?
      @@dash_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Dash::Engine')
    end

    paths['app/controllers'] << 'app/controllers/frontend' << 'app/controllers/backend'
    paths['app/views'] << 'app/views/frontend' << 'app/views/backend'

    config.to_prepare &method(:activate).to_proc
  end
end
