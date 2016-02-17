module QueryParser
  extend ActiveSupport::Concern

  private

  def extracted_query(unfiltered_query)
    @unfiltered_query = unfiltered_query
    if extracted_query_and_scope
      query = extracted_query_and_scope[:query]
    else
      query = unfiltered_query
    end
    query
  end

  def extracted_scope(unfiltered_query)
    @unfiltered_query = unfiltered_query
    if extracted_query_and_scope
      scope = extracted_query_and_scope[:value]
    else
      scope = ''
    end
  end

  def extracted_query_and_scope
    if regex_matches = prefix_scope_multi_regex.match(@unfiltered_query)
      regex_matches
    elsif regex_matches = suffix_scope_multi_regex.match(@unfiltered_query)
      regex_matches
    elsif regex_matches = prefix_scope_regex.match(@unfiltered_query)
      regex_matches
    elsif regex_matches = suffix_scope_regex.match(@unfiltered_query)
      regex_matches
    end
    regex_matches
  end

  def prefix_scope_regex
    /^(?<option>scope):(?<value>\S+)\s?(?<query>.*)$/
  end

  def prefix_scope_multi_regex
    /^(?<option>scope):\((?<value>.*?)\)\s?(?<query>.*)$/
  end

  def suffix_scope_regex
    /(?<query>.*)\s(?<option>scope):(?<value>\S+)/
  end

  def suffix_scope_multi_regex
    /^(?<query>.*)\s(?<option>scope):\((?<value>.*)\)$/
  end

end