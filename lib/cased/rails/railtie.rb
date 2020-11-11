# frozen_string_literal: true

require 'rails/railtie'

module Cased
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'cased.include_controller_helpers' do
        ActiveSupport.on_load(:action_controller) do
          require 'cased/controller_helpers'
          include Cased::ControllerHelpers
        end
      end

      initializer 'cased.instrumentation_controller' do
        ActiveSupport.on_load(:action_controller) do
          require 'cased/instrumentation/controller'
          include Cased::Instrumentation::Controller
        end
      end

      initializer 'cased.include_model' do
        ActiveSupport.on_load(:active_record) do
          require 'cased/model'
          require 'cased/rails/model'

          include Cased::Model
          include Cased::Rails::Model
        end
      end

      initializer 'cased.active_job' do
        ActiveSupport.on_load(:active_job) do
          require 'cased/rails/active_job'
          include Cased::Rails::ActiveJob
        end
      end

      initializer 'cased.rack_middleware' do |app|
        app.middleware.use Cased::RackMiddleware
      end

      # :nocov:
      console do
        Cased.console
      end
    end
  end
end
