# frozen_string_literal: true

module Cased
  class AuthorizationsController < ApplicationController
    def create
      self.cased_authorization = params[:token]
    end

    def destroy
      self.cased_authorization = nil
    end
  end
end
