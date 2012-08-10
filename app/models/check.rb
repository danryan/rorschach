class Check < ActiveRecord::Base
  attr_accessible :critical, :interval, :metric, :repeat, 
    :resolve, :warning, :duration, :handlers
  attr_accessor :value, :previous_state, :current_state

  serialize :handlers

  validates :metric, :presence => true

  after_create :schedule_first_check
  
  def get_value
    metric_url = "#{Rorschach::Config.graphite_url}/render/?target=#{metric}&format=json&from=-#{duration}s"
    headers = {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
    if Rorschach::Config.graphite_auth
      headers['Authorization'] = "Basic #{Base64.encode64(Rorschach::Config.graphite_auth)}"
    end
    raw_data = RestClient.get(metric_url, headers)
    data = JSON.parse(raw_data)
    points = data.first["datapoints"].map{ |v,_| v }.compact
    self.value = ((points.reduce { |a, b| a + b }) / points.size.to_f).to_f
  end

  def schedule_first_check
    CheckWorker.perform_async(id)
  end
  
  def status_changed?
    last_status != current_status
  end

  def notify
    results = { check_id: id, metric: metric, value: last_value, state: state }
    PagerDutyWorker.perform_async(results) if handlers.include?('pagerduty')
    CampfireWorker.perform_async(results) if handlers.include?('campfire')
    EmailWorker.perform_async(results) if handlers.include?('email')
  end

  state_machine :initial => :ok do
    after_transition any => any, :do => :notify

    state :ok
    state :warning
    state :critical

    event :set_warning do
      transition [ :ok, :critical ] => :warning
    end

    event :set_critical do
      transition [ :ok, :warning ] => :critical
    end

    event :set_ok do
      transition [ :warning, :critical ] => :ok
    end

  end
end
