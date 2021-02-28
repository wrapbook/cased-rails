# frozen_string_literal: true

require 'rails/railtie'

module Cased
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'cased.parameter_filter' do |app|
        app.config.filter_parameters << proc do |key, value, _original_params|
          next unless Cased.config.filter_parameters?
          next if Cased.config.unfiltered_parameters.include?(key) || !value.respond_to?(:replace)

          value.replace(ActiveSupport::ParameterFilter::FILTERED)
        end
      end

      initializer 'cased.assets.precompile' do |app|
        app.config.assets.precompile << 'cased/manifest.js'
      end

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

        # We only want to record any non-development or test console sessions.
        next unless ::Rails.env.development? || ::Rails.env.test?

        session = Cased::CLI::InteractiveSession.start(command: "#{Dir.pwd}/bin/rails console")
        # If the session does not need its output recorded, we can bypass any
        # forced exits.
        next unless session.record_output?

        # If we reach this line inside of the recorded session we don't want to
        # exit but instead proceed to the `rails console` as usual.
        #
        # We don't want to enter the parent `rails console` so we exit right
        # away as we know the child `rails console` completed successfully.
        exit unless Cased::CLI::Session.current&.approved?
      end
    end
  end
end
