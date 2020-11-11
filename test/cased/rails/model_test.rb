# frozen_string_literal: true

require 'test_helper'

module Cased
  module Rails
    class ModelTest < ActiveSupport::TestCase
      include Cased::TestHelper

      def test_includes_belongs_to_associations
        post = posts(:blog)

        post.cased(:publish)

        expected_payload = {
          action: 'post.publish',
          post: post,
          user: post.user,
        }

        assert_equal Cased::Rails::Model, post.method(:cased_payload).owner, 'expected Post to not implement cased_payload method'
        assert_cased_events 1, expected_payload
      end

      def test_includes_optional_belongs_to_association_that_exists
        comment = comments(:comment)
        comment.cased(:create)

        expected_payload = {
          action: 'comment.create',
          comment: comment,
          post: comment.post,
          user: comment.user,
        }

        assert_equal Cased::Rails::Model, comment.method(:cased_payload).owner, 'expected Post to not implement cased_payload method'
        assert_cased_events 1, expected_payload
      end

      def test_does_not_include_optional_belongs_to_association_that_returns_nil
        comment = comments(:comment_without_author)
        comment.cased(:create)

        expected_payload = {
          action: 'comment.create',
          comment: comment,
          post: comment.post,
          post_user: comment.post.user,
        }

        events = cased_events_with(expected_payload)

        assert_equal Cased::Rails::Model, comment.method(:cased_payload).owner, 'expected Comment to not implement cased_payload method'
        assert_equal 1, events.length
        assert event = events.pop
        assert_nil event[:user], 'did not expect event to include top level user key'
      end
    end
  end
end
