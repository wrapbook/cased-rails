# frozen_string_literal: true

module Cased
  module Rails
    module Config
      def unfiltered_parameters=(new_unfiltered_parameters)
        @unfiltered_parameters = Array.wrap(new_unfiltered_parameters)
      end

      def unfiltered_parameters
        @unfiltered_parameters ||= [
          # Database record ID's
          'id',
          # Controller actions
          'action',
          # Controller names
          'controller',
        ].freeze
      end

      def skip_recording_console=(should_skip_recording_console)
        @skip_recording_console = should_skip_recording_console
      end

      def skip_recording_console?
        return @skip_recording_console if defined?(@skip_recording_console)
        @skip_recording_console = ::Rails.env.development? || ::Rails.env.test?
      end

      def filter_parameters=(new_filter_parameters)
        @filter_parameters = new_filter_parameters
      end

      def filter_parameters?
        return @filter_parameters if defined?(@filter_parameters)

        @filter_parameters = if ENV['CASED_FILTER_PARAMETERS']
          parse_bool(ENV['CASED_FILTER_PARAMETERS'])
        else
          true
        end
      end
    end
  end
end

Cased::Config.prepend(Cased::Rails::Config)
