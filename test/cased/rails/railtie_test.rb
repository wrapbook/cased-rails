# frozen_string_literal: true

require 'test_helper'

module Cased
  module Rails
    class RailtieTest < ActiveSupport::TestCase
      include ::ActiveJob::TestHelper

      test 'rack middleware is mounted' do
        assert_includes ::Rails.application.middleware.middlewares, Cased::RackMiddleware
      end

      test 'active job serializes cased context in job data' do
        Cased.context.merge('actor' => 'cased')

        actual_context = {}

        TestJob = Class.new(::ActiveJob::Base) do
          before_perform do
            actual_context = Cased.context.context
          end

          def perform; end
        end

        TestJob.perform_now

        expected_context = {
          'actor' => 'cased',
          'job_class' => 'Cased::Rails::RailtieTest::TestJob',
        }

        assert_equal expected_context, actual_context
      end
    end
  end
end
