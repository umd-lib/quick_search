module QueryFilter
  extend ActiveSupport::Concern

  include ActionView::Helpers::TextHelper

  private

  def filter_query(query)
    if query.match(/ -$/)
      query = query.sub(/ -$/,"")
    end
    query.gsub!('*', ' ')
    query.gsub!('!', ' ')
    query.gsub!('-', ' ') # Solr returns an error if multiple dashes appear at start of query string
    query.gsub!('\\', '')
    # query.gsub!('"', '')
    query.strip!
    query.squish!
    query.downcase! # FIXME: Do we really want to downcase everything?
    query = truncate(query, length: 100, separator: ' ', omission: '', escape: false)

    query
  end

end