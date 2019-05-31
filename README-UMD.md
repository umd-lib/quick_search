# QuickSearch UMD-Fork

This repository is a forked version of the NSCU QuickSearch repository,
incorporating UMD-specific changes.

## Changes to NCSU QuickSearch functionality

### Best Bets do not fade out

Modified "app/assets/javascripts/quick_search/quicksearch.js" so that
the Best Bets label remains displayed, instead of fading out after a few
seconds.

### Native search interface link is included in JSON results

Modified "app/controllers/quick_search/search_controller.rb" so that
the link to the native search interface, including query parameters, is
included in the JSON result.

### No results link is included in JSON results

Modified "app/controllers/quick_search/search_controller.rb" so that
the "no_results_link" for the searcher is included in the JSON result.

### Best Bet keywords are passed through "filter_query" method

Query terms entered by the user are passed through the the "filter_query" method
in "app/controllers/concerns/quick_search/query_filter.rb". This modifies the
query term, such as replacing dashes with whitespace.

This is an issue when attempting to match against the Best Bet keywords, as
a keyword with a dash ("-') will never be found. To ensure that such a keyword
will be found, the Best Bet initializer in "lib/quick_search/engine.rb" file has
been modified to pass the keywords through the "filter_query" method. This
ensures that the same textual changes that occur to the query terms are also
applied to the Best Bet keywords.
