module Gherkin
  class AstNode
    # alias TagNode = Hash(Symbol, Symbol | String | Nil)

    getter :rule_type
    @rule_type : Symbol

    def initialize(rule_type)
      @rule_type = rule_type
      # @_sub_items = Hash.new { |hash, key| hash[key] = [] of Gherkin::Token } # returns [] for unknown key
      @_sub_items = Hash(Symbol,Array(Gherkin::Token)).new([] of Gherkin::Token) # returns [] for unknown key
    end

    def add(rule_type, obj)
      @_sub_items[rule_type].push(obj)
    end

    def get_single(rule_type)
      @_sub_items[rule_type].first
    end

    def get_items(rule_type)
      @_sub_items[rule_type]
    end

    def get_token(token_type)
      get_single(token_type)
    end

    def get_tokens(token_type)
      @_sub_items[token_type]
    end
  end
end
