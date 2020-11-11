# frozen_string_literal: true

module Cased
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      before_action :cased_setup_request_context
    end

    private

    def cased_setup_request_context
      Cased.context.merge(cased_initial_request_context)
    end

    def cased_initial_request_context
      {
        location: request.remote_ip,
        request_http_method: request.method,
        request_user_agent: request.headers['User-Agent'],
        request_url: request.original_url,
        request_id: request.request_id,
      }
    end
  end
end
