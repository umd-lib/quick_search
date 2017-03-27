module QuickSearch
  class AppstatsController < ApplicationController
    include Auth

    before_action :auth #, :start_date, :end_date, :days_in_sample


    ########################## ADDED #############################
    def data_sample
      range = date_range(params[:start_date], params[:end_date])
      result = []
      events = Event.where(range).limit(100)
      searches = Search.where(range).limit(100)
      sessions = Session.where(range).limit(100)

      result[0] = events
      result[1] = searches
      result[2] = sessions

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_test
      range = date_range(params[:start_date], params[:end_date])
      result = []
      # events = Event.where(range).limit(100)
      # searches = Search.where(range).limit(100)
      # sessions = Session.where(range).limit(100)

      # result[0] = events
      # result[1] = searches
      # result[2] = sessions
      res1 = Event.select("*").joins("INNER JOIN sessions ON sessions.id=events.session_id").limit(100)
      # res2 = Search.joins("INNER JOIN sessions ON sessions.id=searches.session_id").limit(100)
      # res3 = Session.joins("INNER JOIN events ON events.session_id=sessions.id").limit(100)
      # res4 = Session.joins("INNER JOIN searches ON searches.session_id=sessions.id").limit(100)
      result[0] = res1
      # result[1] = res2
      # result[2] = res3
      # result[3] = res4

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_general_statistics
      range = date_range(params[:start_date], params[:end_date])
      result = []

      clicks = Event.where(range).where(:action => 'click').group(:created_at_string).order("created_at_string ASC").count(:created_at_string)
      clicksSub = []
      clicks.each do |date , count|
        row = { "date" => date ,
                "count" => count}
        clicksSub << row
      end
      result << clicksSub

      serves = Event.where(range).where(:action => 'serve').group(:created_at_string).order("created_at_string ASC").count(:created_at_string)
      servesSub = []
      serves.each do |date , count|
        row = { "date" => date ,
                "count" => count}
        servesSub << row
      end
      result << servesSub

      sessions = Session.where(range).group(:created_at_string).order("created_at_string ASC").count(:created_at_string)
      sessionsSub = []
      sessions.each do |date , count|
        row = { "date" => date ,
                "count" => count}
        sessionsSub << row
      end
      result << sessionsSub

      searches = Search.where(range).group(:created_at_string).order("created_at_string ASC").count(:created_at_string)
      searchesSub = []
      searches.each do |date , count|
        row = { "date" => date ,
                "count" => count}
        searchesSub << row
      end
      result << searchesSub

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_module_clicks
      range = date_range(params[:start_date], params[:end_date])
      clicks = Event.where(range).where(excluded_categories).where(:action => 'click').group(:category).order("count_category DESC").count(:category)
      total_clicks = clicks.values.sum

      i=1
      result = []
      clicks.each do |category, count|
        row = {"rank" => i,
               "label" => category,
               "clickcount" => count,
               "percentage" => ((100.0*count)/total_clicks).round(2),
               "parent" => 0,
               "expanded" => 0,
               "key" => "module" + category}
        result << row
        i += 1
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_result_clicks
      range = date_range(params[:start_date], params[:end_date])
      clicks = Event.where(range).where(:category => "result-types").where(:action => 'click').group(:item).order("count_item DESC").count(:item)
      total_clicks = clicks.values.sum

      i=1
      result = []
      clicks.each do |item, count|
        row = {"rank" => i,
               "label" => item,
               "clickcount" => count,
               "percentage" => ((100.0*count)/total_clicks).round(2),
               "parent" => 0,
               "expanded" => 0,
               "key" => "result" + item}
        result << row
        i += 1
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_module_details
      range = date_range(params[:start_date], params[:end_date])
      category = params[:category]
      clicks = Event.where(:category => category).where(:action => 'click').where(range).group(:item).order('count_category DESC').count(:category)
      total_clicks = clicks.values.sum

      i=1
      result = []
      clicks.each do |item, count|
        row = {"rank" => i,
               "label" => item,
               "clickcount" => count,
               "percentage" => ((100.0*count)/total_clicks).round(2),
               "parent" => category,
               "key" => "module_detail" + item + category}
        result << row
        i += 1
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_top_searches
      range = date_range(params[:start_date], params[:end_date])
      num_results = params[:num_results] ? params[:num_results].to_i : 20
      searches = Search.where(:page => '/').where(range).group(:query).order('count_query DESC').count(:query)
      total_searches = Search.where(:page => '/').where(range).group(:query).order('count_query DESC').count(:query).sum {|k,v| v}

      i=1
      result = []
      last_row = {}
      searches.each do |query, count|
        if i>num_results then
          break
        end
        if (last_row=={}) 
          last_cum_percentage = 0
        else 
          last_cum_percentage = last_row["cum_perc"]
        end
        row = {"rank" => i,
               "label" => query,
               "count" => count,
               "percentage" => ((100.0*count)/total_searches).round(2),
               "cum_perc" => (last_cum_percentage + ((100.0*count)/total_searches)),
               "cum_percentage" => (last_cum_percentage + ((100.0*count)/total_searches)).round(2),
               "key" => "top_search" + query}
        result << row
        last_row = row
        i += 1
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_spelling_suggestions
      range = date_range(params[:start_date], params[:end_date])
      num_results = params[:num_results] ? params[:num_results].to_i : 20
      serves = Event.where(range).where(:category => "spelling-suggestion", :action => 'serve').group(:item).order("count_category DESC").count(:category)
      clicks = Event.where(range).where(:category => "spelling-suggestion", :action => 'click').group(:item).count(:category)

      i=1
      result = []
      serves.each do |item , count|
        if i>num_results then
          break
        end
        click_count = clicks[item] ? clicks[item] : 0
        row = {"rank" => i,
               "label" => item,
               "serves" => count,
               "clicks" =>  click_count,
               "ratio" => (100.0*click_count/count).round(2),
               "key" => "spelling_suggestion" + item}
        result << row
        i+=1
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_best_bets
      range = date_range(params[:start_date], params[:end_date])
      num_results = params[:num_results] ? params[:num_results].to_i : 20
      serves = Event.where(range).where(:category => "best-bet", :action => 'serve').group(:item).order("count_category DESC").count(:category)
      clicks = Event.where(range).where(:category => "best-bet", :action => 'click').group(:item).count(:category)

      i=1
      result = []
      serves.each do |item , count|
        if i>num_results then
          break
        end
        click_count = clicks[item] ? clicks[item] : 0
        row = {"rank" => i,
               "label" => item,
               "serves" => count,
               "clicks" =>  click_count,
               "ratio" => (100.0*click_count/count).round(2),
               "key" => "best_bet" + item}
        result << row
        i+=1
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end
    ##############################################################

    def index
      @page_title = 'Search Statistics'
    end

    def clicks_overview
      @page_title = 'Clicks Overview'
    end

    def top_searches
      @page_title = 'Top Searches'
    end

    def top_spot
      @page_title = params[:ga_top_spot_module]
    end

    def date_range(start, stop)
      if (start!="" && start!=nil)
        sd = convert_to_time(start)
      else
        sd = Time.current - 180.days
      end
      if (stop!="" && stop!=nil)
        ed = convert_to_time(stop)
      else
        ed = Time.current
      end
      puts(sd)
      puts(ed)
      puts(sd..ed)
      return { :created_at => sd..ed }
    end

    def convert_to_time(date_input)
      Time.parse(date_input)
    end

    def days_in_sample
      @days_in_sample = ((@end_date - @start_date) / (24*60*60)).round
      if @days_in_sample < 1
        @days_in_sample = 1
      end
    end

    def excluded_categories
      "category <> \"common-searches\" AND category <> \"result-types\"AND category NOT LIKE \"typeahead-%\""
    end

  end
end
