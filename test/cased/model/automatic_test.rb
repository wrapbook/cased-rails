# frozen_string_literal: true

require 'test_helper'

module Cased
  module Model
    class AutomaticTest < ActiveSupport::TestCase
      include Cased::TestHelper

      test 'create publishes user.create audit event' do
        user = travel_to Time.utc(2020, 1, 1) do
          User.create(email: 'system@cased.com')
        end

        expected_payload = {
          action: 'user.create',
          user_id: "User;#{user.id}",
          timestamp: '2020-01-01T00:00:00.000000Z',
        }

        assert_cased_events 1, expected_payload
      end

      test 'updates publishes user.update audit event' do
        user = User.create(email: 'system@cased.com')

        travel_to Time.utc(2020, 1, 1) do
          user.update(email: 'bot@cased.com')
        end

        expected_payload = {
          action: 'user.update',
          user_id: "User;#{user.id}",
          timestamp: '2020-01-01T00:00:00.000000Z',
        }

        assert_cased_events 1, expected_payload
      end

      test 'destroy publishes user.destroy audit event' do
        user = User.create(email: 'system@cased.com')

        travel_to Time.utc(2020, 1, 1) do
          user.destroy
        end

        expected_payload = {
          action: 'user.destroy',
          user_id: "User;#{user.id}",
          timestamp: '2020-01-01T00:00:00.000000Z',
        }

        assert_cased_events 1, expected_payload
      end
    end
  end
end
