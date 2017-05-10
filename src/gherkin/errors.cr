module Gherkin
  # alias LocationType = Hash(Symbol,Int32)

  class ParserError < Exception
    @errors : Array(Exception)
    getter :errors
    def initialize(@message : String = self.class.name)
      super
      @errors = [] of Exception
    end
  end

  class ParserException < ParserError
    getter :location

    def initialize(@message, @location : Hash(Symbol,Int32)?)
      # @location = location
      line = location && location[:line] ? location[:line] : "(n/a)"
      column = location && location[:column] ? location[:column] : 0
      super("(#{line}:#{column}): #{message}")
    end
  end

  class NoSuchLanguageException < ParserException
    # alias LocationType = Hash(Symbol,Int32)

    def initialize(language, location : Hash(Symbol,Int32)?)
      super "Language not supported: #{language}", location
    end
  end

  class AstBuilderException < ParserException; end

  class CompositeParserException < ParserError

    def initialize(@errors)
      # @errors = errors
      # super "Parser errors:\n" + errors.map(&:message).join("\n")
      super "Parser errors:\n" + errors.map{|m| m.message}.join("\n")
    end
  end

  class UnexpectedTokenException < ParserException
    def initialize(received_token, expected_token_types, state_comment)
      message = "expected: #{expected_token_types.join(", ")}, got '#{received_token.token_value.strip}'"
      column = received_token.location[:column]
      location =  (column.nil? || column.zero?) ? {line: received_token.location[:line], column: received_token.line.indent + 1} : received_token.location
      super(message, location)
    end
  end

  class UnexpectedEOFException < ParserException
    def initialize(received_token, expected_token_types, state_comment)
      message = "unexpected end of file, expected: #{expected_token_types.join(", ")}"
      super(message, received_token.location)
    end
  end
end
