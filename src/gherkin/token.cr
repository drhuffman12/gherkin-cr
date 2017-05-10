module Gherkin
  struct Token
    property :line, :location

    property :matched_type, :matched_text, :matched_keyword, :matched_indent,
                  :matched_items, :matched_gherkin_dialect

    # alias LocationType = Hash(Symbol,Int32)
    # alias LocationType = Hash(Symbol,Int32)
    
    @matched_type : Symbol? = nil
    @matched_text : String? = nil
    @matched_keyword : String? = nil
    @matched_indent : Int32 = 0
    # @matched_items : Array(Gherkin::Token) = [] of Gherkin::Token
    @matched_items : Array(Gherkin::GherkinLine::Span) = [] of Gherkin::GherkinLine::Span
    @matched_gherkin_dialect : String? = nil

    # def initialize(@line : (Gherkin::GherkinLine | Int32)?, @location : Hash(Symbol,Int32))
    def initialize(@line : Gherkin::GherkinLine, @location : Hash(Symbol,Int32) = {:line => 0, :column => 0})
    # ? = Gherkin::GherkinLine.new(nil,0)
    end

    def eof?
      line.nil? || line.line_text.nil?
    end

    def detach
      # TODO: detach line - is this needed?
    end

    def token_value
      eof? ? "EOF" : line.get_line_text(-1)
    end
  end
end
