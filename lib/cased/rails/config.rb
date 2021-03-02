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
