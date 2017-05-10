# require "stringio"
require "../gherkin/token"
require "../gherkin/gherkin_line"

module Gherkin
  # The scanner reads a gherkin doc (typically read from a .feature file) and
  # creates a token for line. The tokens are passed to the parser, which outputs
  # an AST (Abstract Syntax Tree).
  #
  # If the scanner sees a # language header, it will reconfigure itself dynamically
  # to look for Gherkin keywords for the associated language. The keywords are defined
  # in gherkin-languages.json.
  class TokenScanner
    # alias LocationType = Hash(Symbol,Int32)
    @io : IO # IO::Memory is Crystal's version of Ruby's StringIO

    def initialize(source_or_io)
      @line_number = 0

      case(source_or_io)
      when String
        @io = IO::Memory.new(source_or_io)
      when IO::Memory, IO
        @io = source_or_io
      else
        raise ArgumentError.new("Please a pass String, IO::Memory or IO. I got a #{source_or_io.class}")
      end
    end

    # def read
    #   location = {:line => @line_number += 1, :column =>  0}
    #   # if @io.nil? || (line = @io.gets) # TODO: VERIFY THIS CHANGE (from)!!!
    #   # done = false
    #   # if @io # TODO: VERIFY THIS CHANGE (to)!!!
    #     line = @io ? @io.gets : nil
    #     if line
    #       gherkin_line = line ? GherkinLine.new(line, location[:line]) : 0
    #       Token.new(gherkin_line, location)
    #     else
    #       @io.close if @io && !@io.closed? # ARGF closes the last file after final gets
    #       # @io = nil
    #       Token.new(nil, location)
    #     end
    #   # else
    #   #   done = true
    #   # end
    #   # if done
    #   #   # @io.close unless @io.closed? # ARGF closes the last file after final gets
    #   #   @io.close if @io && !@io.closed? # ARGF closes the last file after final gets
    #   #   @io = nil
    #   #   Token.new(nil, location)
    #   # end
    # end

    def read
      location = {:line => @line_number += 1, :column =>  0}
      str = @io ? @io.gets : nil
      if str
        gherkin_line = GherkinLine.new(str, location[:line])
        Token.new(gherkin_line, location)
      else
        @io.close if @io && !@io.closed? # ARGF closes the last file after final gets
        # @io = nil
        # Token.new(nil, location)
        Token.new(GherkinLine.new(nil, 0), location)
      end
    end

    # def read
    #   location = {:line => @line_number += 1, :column =>  0}
    #   if @io.nil? || str = @io.gets
    #     gherkin_line = str ? GherkinLine.new(str, location[:line]) : nil
    #     Token.new(gherkin_line, location)
    #   else
    #     @io.close unless @io.closed? # ARGF closes the last file after final gets
    #     @io = nil
    #     Token.new(nil, location)
    #   end

    #   str = nil
    #   read_again = nil
    #   case
    #     when @io.nil?
    #       read_again = true
    #     when str = @io.gets
    #       read_again = true
    #     else
    #       read_again = false
    #   end
    #   if read_again
    #   else
    #   end

    # end
  end
end
