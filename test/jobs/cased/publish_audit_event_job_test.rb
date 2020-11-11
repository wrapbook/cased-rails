# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

module Cased
  class PublishAuditEventJobTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    test 'publish audit event' do
      ENV['CASED_PUBLISH_KEY'] = 'test'

      stub_request(:post, 'https://publish.cased.com/')
        .to_return(status: 200)

      audit_event = Cased::AuditEvent.create(audit_event: '{"action": "user.login"}')

      assert_difference 'Cased::AuditEvent.count', -1 do
        Cased::PublishAuditEventJob.perform_now(audit_event)
      end
    end

    test 'retries job on server error' do
      ENV['CASED_PUBLISH_KEY'] = 'test'

      stub_request(:post, 'https://publish.cased.com/')
        .to_return(status: 500)

      audit_event = Cased::AuditEvent.create(audit_event: '{"action": "user.login"}')

      assert_enqueued_with(job: Cased::PublishAuditEventJob, args: [audit_event], queue: 'cased') do
        Cased::PublishAuditEventJob.perform_now(audit_event)
      end
    end

    test 'retries job on request timeout' do
      ENV['CASED_PUBLISH_KEY'] = 'test'

      stub_request(:post, 'https://publish.cased.com/')
        .to_return(status: 408)

      audit_event = Cased::AuditEvent.create(audit_event: '{"action": "user.login"}')

      assert_enqueued_with(job: Cased::PublishAuditEventJob, args: [audit_event], queue: 'cased') do
        Cased::PublishAuditEventJob.perform_now(audit_event)
      end
    end

    test 'does not retry job on standard error' do
      ENV['CASED_PUBLISH_KEY'] = 'test'

      stub_request(:post, 'https://publish.cased.com/')
        .to_return(status: 200)

      audit_event = Cased::AuditEvent.create(audit_event: '{"action": "user.login"}')
      audit_event.stubs(:destroy).raises(StandardError)

      assert_enqueued_jobs 0 do
        assert_raises(StandardError) do
          Cased::PublishAuditEventJob.perform_now(audit_event)
        end
      end
    end

    test 'does not delete audit event on server error' do
      ENV['CASED_PUBLISH_KEY'] = 'test'

      stub_request(:post, 'https://publish.cased.com/')
        .to_return(status: 500)

      audit_event = Cased::AuditEvent.create(audit_event: '{"action": "user.login"}')

      assert_no_difference 'Cased::AuditEvent.count' do
        Cased::PublishAuditEventJob.perform_now(audit_event)
      end
    end

    test 'does not delete audit event on request timeout' do
      ENV['CASED_PUBLISH_KEY'] = 'test'

      stub_request(:post, 'https://publish.cased.com/')
        .to_return(status: 408)

      audit_event = Cased::AuditEvent.create(audit_event: '{"action": "user.login"}')

      assert_no_difference 'Cased::AuditEvent.count' do
        Cased::PublishAuditEventJob.perform_now(audit_event)
      end
    end
  end
end
