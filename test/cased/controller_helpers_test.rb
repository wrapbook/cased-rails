# frozen_string_literal: true

require 'test_helper'

module Cased
  class ControllerHelpersTest < ActionDispatch::IntegrationTest
    include Cased::TestHelper

    test 'default context set for all requests' do
      Cased::Context.clear!

      travel_to Time.utc(2020, 1, 1) do
        get root_url, headers: {
          'User-Agent' => 'cased-browser/v1.0',
        }
      end

      expected_payload = {
        location: '127.0.0.1',
        request_http_method: 'GET',
        request_user_agent: 'cased-browser/v1.0',
        request_url: 'http://www.example.com/',
        request_id: response.headers['X-Request-Id'],
        timestamp: '2020-01-01T00:00:00.000000Z',
      }

      assert_cased_events 1, expected_payload
      assert_response :success
    end
  end
end
