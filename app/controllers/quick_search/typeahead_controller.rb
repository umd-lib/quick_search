module QuickSearch
  class TypeaheadController < ApplicationController
    protect_from_forgery except: :typeahead

    # This method should return a list of search suggestions for a given searcher
    # It should return errors if there is no param called 'searcher', if the searcher does not exist
    # or if the searcher doesn't implement the 'typeahead' method
    # Otherwise, it should return the result of calling the 'typeahead' method as JSON

    def typeahead
      # :searcher param expected to be name of a searcher with underscores, ie: ematrix_journal
      searcher = params[:searcher]
      query = params[:q] or ''
      total = params[:total] or 3

      if searcher.blank?
        logger.error "Typeahead request: no searcher param provided"
        head :bad_request
        return nil
      end

      searcher_string = "QuickSearch::#{searcher.camelize}Searcher"

      begin 
        klass = searcher_string.constantize
      rescue NameError
        logger.error "Typeahead request: searcher #{searcher} does not exist"
        head :bad_request
        return nil
      end

      if klass.method_defined? :typeahead
        typeahead_result = klass.new(HTTPClient.new, query, total).typeahead

        if params.has_key? 'callback'
          render json: typeahead_result, callback: params['callback']
        else
          render json: typeahead_result
        end
      else
        logger.error "Typeahead request: searcher #{searcher} has no typeahead method"
        head :bad_request
        return nil
      end
    end

  end
end
