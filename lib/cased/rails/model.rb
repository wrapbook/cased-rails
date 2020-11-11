# frozen_string_literal: true

module Cased
  module Rails
    module Model
      def cased_id
        primary_key_column = self.class.primary_key
        "#{self.class.name};#{send(primary_key_column)}"
      end

      def cased_payload
        {
          cased_category => self,
        }.tap do |payload|
          cased_payload_belongs_to_associations(self, payload)
        end
      end

      private

      # @param payload [Hash] The cased_payload to mutate.
      # @param object [ActiveRecord::Base] The ActiveRecord instance to continue traversing objects on.
      # @param prefix [String, Symbol] The cased
      def cased_payload_belongs_to_associations(object, payload, prefix: nil)
        klass = object.class
        klass.reflect_on_all_associations(:belongs_to).each do |association|
          association_value = object.send(association.name)
          if association_value.nil?
            next if association.options[:optional]

            raise ArgumentError, "Expected #{klass}##{association.name} association to not return nil"
          end

          key = "#{prefix && "#{prefix}_"}#{association.name}".to_sym
          payload[key] = association_value

          cased_payload_belongs_to_associations(association_value, payload, prefix: association.name)
        end
      end
    end
  end
end
