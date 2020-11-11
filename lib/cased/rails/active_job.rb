# frozen_string_literal: true

module Cased
  module Rails
    module ActiveJob
      extend ActiveSupport::Concern

      included do
        attr_accessor :cased_context

        around_perform do |job, block|
          context = (job.cased_context || {})
          context['job_class'] = job.class.name

          Cased.context.merge(context) do
            block.call
          end
        end

        after_perform do
          Cased::Context.clear!
        end
      end

      def deserialize(job_data)
        super

        self.cased_context = (job_data['cased_context'] || {})
      end

      def serialize
        super.merge('cased_context' => Cased::Context.current.context)
      end
    end
  end
end
