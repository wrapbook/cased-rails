# frozen_string_literal: true

require 'test_helper'

module Cased
  module Publisher
    class ResilientPublisherTest < ActiveSupport::TestCase
      class CustomModel
      end

      test 'resilient has default model' do
        publisher = Cased::Publishers::ResilientPublisher.new
        assert_equal Cased::AuditEvent, publisher.model
      end

      test 'can configure resilient model' do
        publisher = Cased::Publishers::ResilientPublisher.new(model: CustomModel)
        assert_equal CustomModel, publisher.model
      end

      test 'publish audit event' do
        publisher = Cased::Publishers::ResilientPublisher.new

        assert_difference 'Cased::AuditEvent.count' do
          publisher.publish(action: 'user.login')
        end
      end
    end
  end
end
