# Best Bets

QuickSearch includes a feature called “Best Bets”, which are high value, prominent, curated search results that appear for certain queries. You are able to specify these in a configuration file, that QuickSearch will then pick up. You are able to specify the keywords that trigger each Best Bet as well.

To update Best Bets:

- In the QuickSearch development environment edit the Best Bets file at [quicksearch_source_directory]/config/best_bets.yml
- Be sure to list each keyword you want to match the Best Bet. These are matched exactly for shorter queries.
- Run the following rake task from the command line:

    bundle exec rake best_bets:update_index

