xml.instruct!
xml.OpenSearchDescription(:xmlns => 'http://a9.com/-/spec/opensearch/1.1/', 'xmlns:moz' => 'http://www.mozilla.org/2006/browser/search/') do
  xml.ShortName(t(:default_title))
  xml.InputEncoding('UTF-8')
  xml.Image("#{asset_url 'homescreen-icon-64x64.png'}", :height => '64', :width =>'64', :type =>'image/png')
  xml.Image("#{asset_url 'favicon.ico'}", :height => '16', :width =>'16', :type => 'image/x-icon')
  xml.Description(t(:opensearch_description))
  xml.Contact(t(:contact_email))
  xml.Url(type: 'text/html', method: 'get', template: root_url + '?q={searchTerms}' )
  xml.moz(:SearchForm, root_url)
end
