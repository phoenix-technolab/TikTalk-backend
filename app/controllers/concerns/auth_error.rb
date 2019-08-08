# frozen_string_literal: true

module AuthError
  class Unauthorized < ::StandardError; end
  class BadRequest < ::StandardError; end
end
