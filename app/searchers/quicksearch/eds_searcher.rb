# module Quicksearch
    
#   class EdsSearcher < Quicksearch::Searcher
    
#     include RubyEDS

#     def search
#       auth_token = self.class.remembered_auth
#       if auth_token.nil?
#         auth_token = self.class.remembered_auth = authenticate_user(APP_CONFIG['eds']['username'], APP_CONFIG['eds']['password'])
#       end
#       session_token = open_session(APP_CONFIG['eds']['profile'], 'n', auth_token)
#       url = api_base_url + api_parameters.to_query
#       raw_response = @http.get(url, {}, headers(auth_token, session_token))
#       close_session(session_token, auth_token)
#       @response = JSON.parse(raw_response.body)
#       if @response['ErrorDescription'] == 'Auth Token Invalid' || @response['ErrorNumber'] == '104'
#         auth_token = self.class.remembered_auth = authenticate_user(APP_CONFIG['eds']['username'], APP_CONFIG['eds']['password'])
#         raw_response = @http.get(url, {}, headers(auth_token, session_token))
#         close_session(session_token, auth_token)
#         @response = JSON.parse(raw_response.body)
#       end
#       @response
#     end

#     def results
#       if results_list
#         results_list
#       else
#         records = response['SearchResult']['Data']['Records']
#         @results_list = []
#         records.each do |value|
#           # TODO: consider how to move this out to a results object
#           result = OpenStruct.new
#           result.title = title(value)
#           result.link = link(value)
#           @results_list << result
#         end
#         @results_list
#       end
#     end

#     def loaded_link
#       loaded_link_base_url
#     end

#     def total
#       @response['SearchResult']['Statistics']['TotalHits']
#     end

#     # Nabbed from BentoSearch
#     # https://github.com/jrochkind/bento_search/blob/2d16d6d928dc8937605c29ab9cd10a6e20c4fdf1/app/search_engines/bento_search/eds_engine.rb#L114
#     @@remembered_auth = nil
#     @@remembered_auth_lock = Mutex.new
#     # Class variable to save current known good auth
#     # uses a mutex to be threadsafe. sigh. 
#     def self.remembered_auth
#       @@remembered_auth_lock.synchronize do      
#         @@remembered_auth
#       end
#     end
#     # Set class variable with current known good auth. 
#     # uses a mutex to be threadsafe. 
#     def self.remembered_auth=(token)
#       @@remembered_auth_lock.synchronize do
#         @@remembered_auth = token
#       end
#     end

#   private

#     def api_base_url
#       'http://eds-api.ebscohost.com/edsapi/rest/Search?'
#     end

#     def loaded_link_base_url
#       'http://ncsu.summon.serialssolutions.com/search?'
#     end

#     def api_parameters
#       {
#         'facetfilter' => '1,SourceType:Academic Journals',
#         'resultsperpage' => @per_page,
#         'query-1' => 'AND,' << @q
#       }
#     end

#     def headers(auth_token, session_token)
#       {
#         'x-authenticationToken' => auth_token,
#         'x-sessionToken' => session_token,
#         'Accept' => 'application/json'
#       }
#     end

#     def title(value)
#       if value.has_key?('RecordInfo')
#         if value['RecordInfo'].has_key?('BibRecord')
#           if value['RecordInfo']['BibRecord'].has_key?('BibEntity')
#             if value['RecordInfo']['BibRecord']['BibEntity'].has_key?('Titles')
#              value['RecordInfo']['BibRecord']['BibEntity']['Titles'][0]['TitleFull']
#             else
#               'Titles'
#             end
#           else
#             'BibEntity'
#           end
#         else
#           'BibRecord'
#         end
#       else
#         'RecordInfo'
#       end
#     end

#     def author
#       value
#     end

#     def link(value)
#       value['PLink']
#     end

#   end
# end
