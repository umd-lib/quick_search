module OnCampus
  extend ActiveSupport::Concern

  private

  # Search for "Nucleation and growth mechanism of ferroelectric domain wall motion"
  # To test this. Result should not show up in Summon results off campus.

  ### WHY THIS IS HERE ###
  # There is a subset of Summon results that cannot be shown unless a person is
  # on campus or authenticated. So that we can show all results to people
  # searching QuickSearch from on campus we're checking IP addresses. If the IP is a
  # known campus IP we set the s.role=authenticated parameter in the Summon API request.

  def ip
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end

  def on_campus?(ip)
    ip = remote_ip(ip)
    ip_range_check(ip)
  end

  # To spoof ON and OFF campus for development
  def remote_ip(ip)
    if ip == '127.0.0.1'
      '204.84.244.1' #On Campus
      #'127.0.0.1'  #Off Campus
    else
      ip
    end
  end

  def ip_range_check(ip)
    APP_CONFIG['on_campus'].each do |on_campus_ip_regex|
      if on_campus_ip_regex === ip
        return true
      end
    end

    return false
  end
end
