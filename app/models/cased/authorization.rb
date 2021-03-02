# frozen_string_literal: true

require 'jwt'

module Cased
  class Authorization
    class MissingApplicationKey < StandardError
      MESSAGE = <<~MSG
        Missing GUARD_APPLICATION_KEY or Cased.config.guard_application_key.
      MSG

      def initialize
        super(MESSAGE)
      end
    end

    ALGORITHM = 'HS256'

    def self.load!(token)
      raise MissingApplicationKey if Cased.config.guard_application_key.blank?

      # JWT.decode will raise here if the token has expired or the application
      # key does not match meaning it has been tampered with.
      data, = JWT.decode(token, Cased.config.guard_application_key, true, algorithm: ALGORITHM)

      new(
        user: data.fetch('user'),
        user_id: data.fetch('user_id'),
        expires_at: data.fetch('exp'),
        issuer: data.fetch('iss'),
        issued_at: data.fetch('iat'),
      )
    end

    def self.validate!(token)
      load!(token)
    end

    attr_reader :user
    attr_reader :user_id
    attr_reader :issued_at
    attr_reader :expires_at
    attr_reader :issuer

    def initialize(user:, user_id:, issued_at:, expires_at:, issuer:)
      @user = user
      @user_id = user_id
      @issued_at = Time.at(issued_at)
      @expires_at = Time.at(expires_at)
      @issuer = issuer
    end

    def token
      user_id
    end

    def to_s
      user
    end

    def to_param
      user_id
    end
  end
end
