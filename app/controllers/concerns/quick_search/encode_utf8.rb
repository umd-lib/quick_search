module QuickSearch::EncodeUtf8
  extend ActiveSupport::Concern

  private

  def params_q_scrubbed
    unless params[:q].nil?
      params[:q].scrub
    end
  end

end
