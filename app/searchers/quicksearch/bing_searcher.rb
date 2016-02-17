# module Quicksearch
#   class BingSearcher < Quicksearch::Searcher

#     def search
#       # response = @http.get(complete_url)
#       # @response = JSON.parse(response.body)

#       uri = URI(complete_url)

#       req = Net::HTTP::Get.new(uri.request_uri)
#       req.basic_auth '', account_key

#       response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https'){|http|
#         http.request(req)
#       }
#       @response = JSON.parse(response.body)
#     end

#     def results
#       if results_list
#         results_list
#       else
#         @results_list = []
#         @response['d']['results'].each do |value|
#           result = OpenStruct.new
#           result.title = title(value)
#           result.link = link(value)
#           result.description = description(value)
#           @results_list << result
#         end
#         @results_list
#       end
#     end

#     def total
#       @response['d']['results'].count.to_s
#     end

#     def loaded_link
#       "website/?q=" << escaped_params_q
#     end

#     def paging
#       Kaminari.paginate_array(results, total_count: total.to_i).page(@page).per(@per_page)
#     end

#     private

#     def account_key
#       'urS2IQ74OZQwQ0RUr1aycNEBctt9mX4T1rKZWEhOTZk'
#     end

#     def base_url
#       "https://api.datamarket.azure.com/Bing/SearchWeb/v1/Web?"
#     end

#     def parameters
#       parameters = {
#         '$top' => '100',
#         '$skip' => @offset,
#         '$format' => 'json',
#         'Query' => "'#{@q} (site:lib.ncsu.edu)'"
#       }
#       parameters
#     end

#     def complete_url
#       base_url + parameters.to_query
#     end

#     def title(value)
#       value['Title']
#     end

#     def link(value)
#       value['Url']
#     end

#     def description(value)
#       value['Description']
#     end

#   end
# end