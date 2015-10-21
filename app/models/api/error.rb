module Api::Error
  class ErrorBuilder
    def self.build(code, default_message)
      error_class = Class.new(StandardError) do
        attr_accessor :message

        def initialize(message = nil)
          @message = message || default_message
        end

        def as_json(args={})
          { error: { message: message, code: code }}
        end
      end

      error_class.send :define_method, :code do
        code
      end
      error_class.send :define_method, :default_message do
        default_message
      end

      error_class
    end
  end

  Unauthenticated = ErrorBuilder.build(32, 'Could not authenticate you.')
  InvalidRecord = ErrorBuilder.build(133, 'Invalid Record.')
  Unauthorized = ErrorBuilder.build(179, 'You are not authorized to do that.')

end
