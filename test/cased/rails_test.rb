# frozen_string_literal: true

require 'test_helper'

module Cased
  class RailsTest < ActiveSupport::TestCase
    test 'truth' do
      assert_kind_of Module, Cased::Rails
    end
  end
end
