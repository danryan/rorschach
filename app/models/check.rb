class Check < ActiveRecord::Base
  attr_accessible :critical, :interval, :metric, :repeat, 
    :resolve, :warning, :duration, :handlers, :scheduled, :last_value
    
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
    if data.present? 
      points = data.first["datapoints"].map{ |v,_| v }.compact
      self.value = ((points.reduce { |a, b| a + b }) / points.size.to_f).to_f
    else
      self.value = nil
    end
  end

  def schedule_first_check
    CheckWorker.perform_async(id)
  end
  
  def one_time_schedule
    OneTimeCheckWorker.perform_async(id)
  end
  
  # def schedule
  #   CheckWorker.perform_async(id)
  #   update_attributes(scheduled: true)
  # end
  
  def schedule
    CheckWorker.perform_in(interval, id) 
  end
  
  state_machine :initial => :ok do
    after_transition any => any do |check, transition|
      event = { 
        check_id: check.id,
        metric: check.metric,
        value: check.last_value,
        from: transition.from,
        to: transition.to
      }
      
      PagerDutyWorker.perform_async(event) if check.handlers.include?('pagerduty')
      CampfireWorker.perform_async(event) if check.handlers.include?('campfire')
      EmailWorker.perform_async(event) if check.handlers.include?('email')
      
      Rorschach.redis do |c|
        c.lpush "events", event.to_json
        c.ltrim "events", 0, 100
      end
      
    end
    
    state :ok
    state :warning
    state :critical

    event :set_warning do
      transition any => :warning
    end

    event :set_critical do
      transition any => :critical
    end

    event :set_ok do
      transition any => :ok
    end

    event :set_undefined do
      transition any => :undefined
    end
  end
end
