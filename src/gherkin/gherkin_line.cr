module Gherkin
  class GherkinLine
    getter :indent, :trimmed_line_text, :line_text, :line_number
    @trimmed_line_text : String
    @indent : Int32
    
    def initialize(@line_text : String?, @line_number : Int32)
      # @line_text = line_text
      # @line_number = line_number
      @trimmed_line_text = (@line_text || "").lstrip
      @indent = (@line_text || "").size - @trimmed_line_text.size
    end

    def start_with?(prefix)
      @trimmed_line_text.starts_with?(prefix)
    end

    def start_with_title_keyword?(keyword)
      start_with?(keyword+":") # The C# impl is more complicated. Find out why.
    end

    def get_rest_trimmed(size)
      @trimmed_line_text[size..-1].strip
    end

    def empty?
      @trimmed_line_text.empty?
    end

    def get_line_text(indent_to_remove)
      indent_to_remove ||= 0
      if indent_to_remove < 0 || indent_to_remove > indent
        @trimmed_line_text
      else
        @line_text[indent_to_remove..-1]
      end
    end

    def table_cells
      cells = [] of String

      self.split_table_cells(@trimmed_line_text) do |item, column|
        cell_indent = item.size - item.lstrip.size
        span = Span.new(@indent + column + cell_indent, item.strip)
        cells.push(span)
      end

      cells
    end

    def split_table_cells(row)
      col = 0
      start_col = col + 1
      cell = ""
      first_cell = true
      while col < row.size
        char = row[col]
        col += 1
        if char == "|"
          if first_cell
            # First cell (content before the first |) is skipped
            first_cell = false
          else
            yield cell, start_col
          end
          cell = ""
          start_col = col + 1
        elsif char == "\\"
          char = row[col]
          col += 1
          if char == "n"
            cell += "\n"
          else
            cell += "\\" unless ["|", "\\"].include?(char)
            cell += char
          end
        else
          cell += char
        end
      end
      # Last cell (content after the last |) is skipped
    end

    def tags
      column = @indent + 1;
      items = @trimmed_line_text.strip.split("@")
      items = items[1..-1] # ignore before the first @
      items.map do |item|
        size = item.size
        span = Span.new(column, "@" + item.strip)
        column += size + 1
        span
      end
    end

    # class Span < Struct.new(:column, :text); end
    struct Span
      property :column, :text
      def initialize(@column : Int32, @text : String)
      end
    end
  end
end
