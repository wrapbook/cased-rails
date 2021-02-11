# frozen_string_literal: true

module Cased
  module Guard
    class SessionsController < ApplicationController
      def show
        guard_session = Cased::Guard::Session.find(params[:guard_session_id])

        respond_to do |format|
          format.html do
            render partial: 'cased/guard/sessions/form', locals: { guard_session: guard_session }
          end

          format.json do
            render partial: 'cased/guard/sessions/guard_session', locals: { guard_session: guard_session }
          end
        end
      end

      def cancel
        guard_session = Cased::Guard::Session.find(params[:guard_session_id])
        guard_session.cancel

        respond_to do |format|
          format.html do
            safe_redirect_back
          end
          format.json do
            render partial: 'cased/guard/sessions/guard_session', locals: { guard_session: guard_session }
          end
        end
      end

      private

      def safe_redirect_back(allow_other_host: false, **args)
        referer = params[:referer]
        redirect_to_referer = referer && (allow_other_host || url_host_allowed?(referer))
        redirect_to redirect_to_referer ? referer : guard_fallback_location, **args
      end

      def url_host_allowed?(url)
        uri = URI(url.to_s)

        # We're redirecting to a path on app.cased.com, that is okay.
        return true if uri.host.blank?

        uri.host == request.host
      rescue ArgumentError, URI::Error
        false
      end
    end
  end
end
