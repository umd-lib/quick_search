# Endpoints

## Search Endpoints

The following endpoints enable various types of searches to be performed.

### Root Endpoint

The root endpoint has the form:

```
(SERVER_URL)/?q=(QUERY_TERM)
```

where

* (SERVER_URL): The base URL of the server
* (QUERY_TERM): The query term

The root endpoint returns different layouts, based on whether or not a search
query parameter, "q", is provided.

If a search query parameter is not provided, the root endpoint returns the
"home" page for the application. Unique to the "home" page is the list of
"common searches", from the "common_searches" property in the
"config/quicksearch_config.yml" file.

If a search query parameter is provided, multiple threads are created, one for
each searcher, and an HTTP request for the search results is made. Each request
is configured with a timeout, using the "http_timeout" property in the
"config/quicksearch_config.yml" file.

Once each searcher has returned (or failed to return within the timeout), the
search results page (app/views/quick_search/search/index.html.erb) is displayed.

If a searcher has failed due to a timeout, the search results page contains
JavaScript (app/assets/javascripts/quick_search/xhr_search.js) which will make
an AJAX request via the "xhr_search" endpoint (see below) for the results for
that searcher.

The root endpoint only returns an HTML page.

### xhr_search Endpoint

The "xhr_search" endpoint is called using a URL of the following form:

```
(SERVER_URL)/xhr_search.(FORMAT)?q=(QUERY_TERM)&endpoint=(ENDPOINT)&page=(PAGE)&template=(TEMPLATE)
```

where

* (SERVER_URL): The base URL of the server
* (FORMAT): Either "html" or "json"
* (QUERY_TERM): The query term
* (ENDPOINT): The name of the searcher, from the "searchers"
  property of the "config/quicksearch_config.yml" file.
* (PAGE): Optional parameter - The page number of the results to return
* (TEMPLATE): Optional paramater - use "with_paging" for paged results.

For example, to search for "art" using the Wikipedia searcher:

```
http://localhost:3000/xhr_search.html?q=art&endpoint=wikipedia
```

As noted in the "Root Endpoint" section, the "xhr_search" endpoint is used by
JavaScript to handle slow responses from searchers. It can also be called
directly, to facilitate using QuickSearch as an API.

The "html" format wraps an HTML fragment in a JSON response, and is what is used
by the "xhr_search.js" JavaScript for retrieving results.

The "json" format is a pure JSON response, suitable when using QuickSearch as
an API.

The endpoint names are based on the names of the searchers in the "searchers"
property of the "config/quicksearch_config.yml" file.

### searcher Endpoint

The "searcher" endpoint enables individual searchers to be used, with a URL
of the following form:

```
(SERVER_URL)/searcher/(ENDPOINT)
```

where

* (SERVER_URL): The base URL of the server
* (ENDPOINT): The name of the searcher, from the "searchers"
  property of the "config/quicksearch_config.yml" file.

For example, to search using the Wikipedia searcher:

```
http://localhost:3000/searcher/wikipedia
```

When using this endpoint, an "app/views/quick_search/search/(ENDPOINT)_search.html.erb"
view must exist.

The "searcher" endpoint also supports functionality similar to the "xhr_search"
endpoint, using the following form:

```
(SERVER_URL)/searcher/(ENDPOINT)/xhr_search.(FORMAT)?q=(QUERY_TERM)&endpoint=(ENDPOINT)&page=(PAGE)&template=(TEMPLATE)
```

**Note:** This usage is the same as that provided by the "xhr_search" endpoint,
so using the "xhr_search" endpoint is preferred.

### opensearch Endpoint

The "opensearch" endpoint returns an OpenSearch v1.1 OpenSearchDescription.

See [http://www.opensearch.org](http://www.opensearch.org) for more information.
