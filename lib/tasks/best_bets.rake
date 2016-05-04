namespace :best_bets do
  desc 'Update the BestBets SOLR index from best_bets.yml'
  task :update_index => :environment do
    require 'rsolr'

    best_bets_yaml = File.join Rails.root, "/config/best_bets.yml"
    best_bets = YAML.load_file(best_bets_yaml)['best_bets']

    solr = RSolr.connect :url => QuickSearch::Engine::APP_CONFIG['best_bets']['solr_url']

    solr.delete_by_query('*:*') 

    records = []

    best_bets.each do |id, value|
        record = {
            :id => id,
            :title => value['title'],
            :url => value['url'],
            :description => value['description'],
            :keywords => value['keywords']
        }
        records << record
    end

    solr.add(records)
    solr.commit

  end

end
