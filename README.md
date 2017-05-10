# gherkin_cr

TODO: Write a description here

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  gherkin_cr:
    github: [your-github-name]/gherkin_cr
```

## Usage

```crystal
require "gherkin_cr"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/gherkin_cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Daniel Huffman - creator, maintainer


## TODO:

* finish porting; fix error:

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
