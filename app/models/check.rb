class Check < ActiveRecord::Base
  attr_accessible :critical, :interval, :metric, :repeat, 
    :resolve, :warning, :duration
  
  validates :metric, :presence => true
  
  
  def metric_url
    "#{Rorschach.graphite_url}/render/?target=#{metric}&format=json&from=-#{duration}s"
  end
  
  def headers
    headers = {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
    if Rorschach.graphite_auth
      headers['Authorization'] = "Basic #{Base64.encode64(Rorschach.graphite_auth)}"
    end
    headers
  end
    
  def get_value
    raw_data = RestClient.get(metric_url, headers)
    data = JSON.parse(raw_data)
    points = data.first["datapoints"].map{ |v,_| v }.compact
    value = ((points.reduce { |a, b| a + b }) / points.size.to_f)
  end
  
end
