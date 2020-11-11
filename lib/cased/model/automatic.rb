# frozen_string_literal: true

module Cased
  module Model
    module Automatic
      extend ActiveSupport::Concern

      included do
        after_commit :publish_cased_create, on: :create
        after_commit :publish_cased_update, on: :update
        after_commit :publish_cased_destroy, on: :destroy
      end

      private

      def publish_cased_create
        cased :create
      end

      def publish_cased_update
        cased :update
      end

      def publish_cased_destroy
        cased :destroy
      end
    end
  end
end
