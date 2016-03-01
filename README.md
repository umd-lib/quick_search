# QuickSearch

QuickSearch is a customized federated search tool designed to connect people to a variety of library resources, services, and tools. QuickSearch is designed to complement and increase use of existing dedicated library resource discovery tools, such as the catalog, electronic resource search, and subject guides/portals, by directing people to them via an intuitive search interface. The aim of QuickSearch is to provide people with a quick and easy way to find the information they need.

## Features

- Single search with bento-box style results
- Modular
  - swap out searcher modules and themes easily
  - choose from a variety of existing searchers or create your own
- Best Bets
- Search analytics

## Disclaimer

This code has been extracted from the code we have been running in
production, but still should be considered an early release.

## Installation

The aim of QuickSearch is to make it very easy to get up and running. There are several ways that you can go about installing it, depending on your situation.

### Vagrant

If you’re interested in trying out QuickSearch, or you’re a developer looking to get a development environment up and running, the easiest way is to use Vagrant to create a virtual environment which automatically installs QuickSearch and its dependencies in only a couple easy steps.

#### Prerequisites

- Vagrant 1.8+ (http://www.vagrantup.com)
- VirtualBox (https://www.virtualbox.org/wiki/Downloads)

#### Instructions

Clone this repository

    git clone git@github.com:ncsu-libraries/quick_search

Change into the cloned directory

    cd quick_search

Run

    vagrant up

Once this completes, you'll have a running instance of QuickSearch
available at http://localhost:8888/

### Manual Installation

#### Prerequisites

- Rails 4.0
- Ruby 2.1
- MySQL development headers (mysql-devel package on CentOS)
- qtwebkit development headers (qtwebkit-devel package on CentOS)

#### Instructions

Clone the main repository:

    git clone https://github.com/ncsu-libraries/quick_search

Create main configuration files, secret token:

- quick_search/config/quicksearch_config.yml
- quick_search/config/database.yml
- quick_search/config/initializers/secret_token.rb

In your working copy of quicksearch, install dependencies:

    bundle install

The application also logs searches and clicks to a database, so you'll need to run migrations to get a local database setup:

    rake db:migrate

Start the server:

    bundle exec rails s

QuickSearch will be available at http://localhost:3000/

## Customizing QuickSearch

QuickSearch is built in a modular way, and is easy to modify or extend.
For more in-depth documentation about this, see:

- Customizing QuickSearch Searchers
- Customizing QuickSearch Themes

### Searchers

Here are a list of searchers that have been created for QuickSearch so
far. Feel free to submit a pull request to add to this list.

|Searcher    |Repository URL                                                      |
|------------|--------------------------------------------------------------------|
|Summon      |http://github.ncsu.edu/kdbeswic/quicksearch_summon_searcher         |
|arXiv       |http://github.ncsu.edu/kdbeswic/quicksearch_arxiv_searcher          |
|Wikipedia   |http://github.ncsu.edu/kdbeswic/quicksearch_wikipedia_searcher      |
|OpenLibrary |http://github.ncsu.edu/kdbeswic/quicksearch_open_library_searcher   |


### Themes

|Theme          |Repository URL                                                      |
|---------------|--------------------------------------------------------------------|
|Generic Theme  |http://github.ncsu.edu/kdbeswic/quicksearch_generic_theme           |


## TODO

There are still some TODOs left in terms of extracting this code from
our production codebase:

- Fix tests

## Bugs, Feature Requests, etc.

To report bugs, or request features, please use GitHub issues. We also
welcome pull requests!

## License

See MIT-LICENSE
