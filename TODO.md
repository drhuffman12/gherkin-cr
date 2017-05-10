## TODO:

* finish porting; fix error(s):

```sh
$ crystal spec
Error in line 2: while requiring "./spec/parser_spec.cr"

in spec/parser_spec.cr:13: instantiating 'Gherkin::Parser#parse(Gherkin::TokenScanner)'

      ast = parser.parse(scanner)
                   ^~~~~

in src/gherkin/parser.cr:73: instantiating 'parse(Gherkin::TokenScanner, Gherkin::TokenMatcher)'

    def parse(token_scanner, token_matcher=TokenMatcher.new)
    ^

in src/gherkin/parser.cr:90: instantiating 'match_token(Int32, Gherkin::Token, Gherkin::ParserContext)'

        state = match_token(state, token, context)
                ^~~~~~~~~~~

in src/gherkin/parser.cr:236: instantiating 'match_token_at_0(Gherkin::Token, Gherkin::ParserContext)'

        match_token_at_0(token, context)
        ^~~~~~~~~~~~~~~~

in src/gherkin/parser.cr:326: instantiating 'match_FeatureLine(Gherkin::ParserContext, Gherkin::Token)'

      if match_FeatureLine(context, token)
         ^~~~~~~~~~~~~~~~~

in src/gherkin/parser.cr:166: instantiating 'Gherkin::TokenMatcher#match_FeatureLine(Gherkin::Token)'

        context.token_matcher.match_FeatureLine(token)
                              ^~~~~~~~~~~~~~~~~

in src/gherkin/token_matcher.cr:36: undefined method 'feature_keywords' for Nil (compile-time type is (Gherkin::Dialect | Nil))

      feature_keywords = @dialect.feature_keywords if !@dialect.is_a?(Nil)
                                  ^~~~~~~~~~~~~~~~

Rerun with --error-trace to show a complete error trace.
```
