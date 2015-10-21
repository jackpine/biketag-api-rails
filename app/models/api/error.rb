module Api::Error
  class ErrorBuilder
    ERROR_MESSAGES = {
      32 => 'Could not authenticate you.',
      133 => 'Invalid Record.',
      179 => 'You are not authorized to do that.'
    }

    def self.build(code)
      default_message = ERROR_MESSAGES[code]
      raise Exception.new("unknown error code: #{code}") if default_message.blank?

      error_class = Class.new(StandardError) do
        attr_accessor :message

        def initialize(message = nil)
          @message = message || default_message
        end

        def as_json(args={})
          { error: { message: message, code: code }}
        end
      end
      error_class.send :define_method, :default_message do 
        default_message
      end
      error_class.send :define_method, :code do
        code
      end

      error_class
    end
  end

  Unauthorized = ErrorBuilder.build(179)
  InvalidRecord = ErrorBuilder.build(133)
  Unauthenticated = ErrorBuilder.build(32)
end
