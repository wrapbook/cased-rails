# frozen_string_literal: true

require 'test_helper'

module Cased
  class AuditEventTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    test 'create audit event' do
      assert_difference 'Cased::AuditEvent.count' do
        Cased::AuditEvent.create(
          audit_event_id: SecureRandom.hex,
          audit_event: '{"action": "user.login"}',
        )
      end
    end

    test 'generates audit_event_id if one is not set' do
      audit_event = Cased::AuditEvent.new

      refute audit_event.audit_event_id?
      refute audit_event.valid?
      assert_not_empty audit_event.audit_event_id
    end

    test 'enqueues active job upon creation' do
      audit_event = Cased::AuditEvent.new(audit_event: '{"action": "user.login"}')

      assert_enqueued_with(job: Cased::PublishAuditEventJob, args: [audit_event], queue: 'cased') do
        audit_event.save
      end
    end
  end
end
