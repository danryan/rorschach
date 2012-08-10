class CheckWorker
  include Sidekiq::Worker

  def perform(id)
    check = Check.find(id)
    
    metric = check.metric
    value = check.get_value
    warning = check.warning
    critical = check.critical
    last_state = check.state
    
    if critical > warning
      current_state = case 
        when value >= critical
          'critical'
        when value >= warning
          'warning'
        else
          'ok'
      end
    else
      current_state = case
        when value <= critical
          'critical'
        when value <= warning
          'warning'
        else
          'ok'
      end
    end
    
    check.last_value = value
    check.save
    
    if current_state != last_state
      Rails.logger.info current_state: current_state, last_state: last_state
      check.send("set_#{current_state}")
    else
      Rails.logger.info "nothing to see here"
    end

    Rails.logger.debug check_id: check.id, metric: check.metric, value: value,  state: current_state
  
    self.class.perform_in(check.interval, check.id)
    
  end
end
