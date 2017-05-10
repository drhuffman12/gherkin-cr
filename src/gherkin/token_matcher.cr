require "../gherkin/dialect"
require "../gherkin/errors"

module Gherkin
  class TokenMatcher
    LANGUAGE_PATTERN = /^\s*#\s*language\s*:\s*([a-zA-Z\-_]+)\s*$/
    # alias LocationType = Hash(Symbol,Int32)
    # Hash(Symbol, Int32)

    @active_doc_string_separator : String?
    @dialect : Dialect?
    # property :dialect # : Dialect

    def initialize(@dialect_name : String = "en")
      @default_dialect_name = dialect_name
      # @dialect = nil
      change_dialect(dialect_name, nil)
      reset
    end

    def reset
      change_dialect(@default_dialect_name, nil) unless @dialect_name == @default_dialect_name
      @active_doc_string_separator = nil
      @indent_to_remove = 0
    end

    def match_TagLine(token)
      return false unless token.line.start_with?("@")

      set_token_matched(token, :TagLine, nil, nil, nil, token.line.tags)
      true
    end

    def match_FeatureLine(token)
      feature_keywords = [] of String
      feature_keywords = @dialect.feature_keywords if !@dialect.is_a?(Nil)
      match_title_line(token, :FeatureLine, feature_keywords)
    end

    def match_ScenarioLine(token)
      match_title_line(token, :ScenarioLine, @dialect.scenario_keywords)
    end

    def match_ScenarioOutlineLine(token)
      match_title_line(token, :ScenarioOutlineLine, @dialect.scenario_outline_keywords)
    end

    def match_BackgroundLine(token)
      match_title_line(token, :BackgroundLine, @dialect.background_keywords)
    end

    def match_ExamplesLine(token)
      match_title_line(token, :ExamplesLine, @dialect.examples_keywords)
    end

    def match_TableRow(token)
      return false unless token.line.start_with?("|")
      # TODO: indent
      set_token_matched(token, :TableRow, nil, nil, nil, token.line.table_cells)
      true
    end

    def match_Empty(token)
      return false unless token.line.empty?
      set_token_matched(token, :Empty, nil, nil, 0)
      true
    end

    def match_Comment(token)
      return false unless token.line.start_with?("#")
      text = token.line.get_line_text(0) #take the entire line, including leading space
      set_token_matched(token, :Comment, text, nil, 0)
      true
    end

    def match_Language(token)
      return false unless token.line.trimmed_line_text =~ LANGUAGE_PATTERN

      dialect_name = $1
      set_token_matched(token, :Language, dialect_name)

      change_dialect(dialect_name, token.location)

      true
    end

    def match_DocStringSeparator(token)
      if @active_doc_string_separator.nil?
        # open
        _match_DocStringSeparator(token, "\"\"\"", true) ||
        _match_DocStringSeparator(token, "```", true)
      else
        # close
        _match_DocStringSeparator(token, @active_doc_string_separator, false)
      end
    end

    def _match_DocStringSeparator(token, separator, is_open)
      return false unless token.line.start_with?(separator)

      content_type = nil
      if is_open
        content_type = token.line.get_rest_trimmed(separator.size)
        @active_doc_string_separator = separator
        @indent_to_remove = token.line.indent
      else
        @active_doc_string_separator = nil
        @indent_to_remove = 0
      end

      # TODO: Use the separator as keyword. That"s needed for pretty printing.
      set_token_matched(token, :DocStringSeparator, content_type)
      true
    end

    def match_EOF(token)
      return false unless token.eof?
      set_token_matched(token, :EOF)
      true
    end

    def match_Other(token)
      text = token.line.get_line_text(@indent_to_remove) # take the entire line, except removing DocString indents
      set_token_matched(token, :Other, unescape_docstring(text), nil, 0)
      true
    end

    def match_StepLine(token)
      keywords = @dialect.given_keywords +
                 @dialect.when_keywords +
                 @dialect.then_keywords +
                 @dialect.and_keywords +
                 @dialect.but_keywords

      keyword = keywords.detect { |k| token.line.start_with?(k) }

      return false unless keyword

      title = token.line.get_rest_trimmed(keyword.size)
      set_token_matched(token, :StepLine, title, keyword)
      return true
    end

    private def change_dialect(dialect_name, location : Hash(Symbol,Int32)?)
      dialect = Dialect.for(dialect_name)
      raise NoSuchLanguageException.new(dialect_name, location) if dialect.nil?

      @dialect_name = dialect_name
      @dialect = dialect
    end

    private def match_title_line(token, token_type, keywords)
      keyword = keywords.detect { |k| token.line.start_with_title_keyword?(k) }

      return false unless keyword

      title = token.line.get_rest_trimmed(keyword.size + ":".size)
      set_token_matched(token, token_type, title, keyword)
      true
    end

    private def set_token_matched(token, matched_type, text=nil, keyword=nil, indent : Int32? = nil, items = [] of Gherkin::GherkinLine::Span) # Gherkin::Token
      token.matched_type = matched_type
      token.matched_text = text && text.chomp
      token.matched_keyword = keyword
      # token.matched_indent = indent || (token.line && token.line.indent) || 0
      token.matched_indent = case
        when indent
          indent
        when (token && token.line && typeof(token.line) == Int32)
          raise "Wrong line type (Int32); should be Gerkin::GherkinLine"
        when (token && token.line && token.line.nil?)
          raise "Wrong line type (Nil); should be Gerkin::GherkinLine"
        when (token && token.line && !token.line.nil?)
          begin
            token.line.indent
          rescue Exception
            0
          end
        else 0
      end
      token.matched_items = items
      if token.location.nil?
        token.location = {:line => 0, :column => 0}
      end
      token.location[:column] = token.matched_indent + 1
      token.matched_gherkin_dialect = @dialect_name
    end

    private def unescape_docstring(text)
      @active_doc_string_separator ? text.gsub("\\\"\\\"\\\"", "\"\"\"") : text
    end
  end
end
