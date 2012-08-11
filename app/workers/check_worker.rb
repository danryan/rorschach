class CheckWorker
  include Sidekiq::Worker

  def perform(id)
    check = Check.find(id)
    
    metric = check.metric
    value = check.get_value
    warning = check.warning
    critical = check.critical
    last_state = check.state
    
    if value
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
    else
      current_state = 'undefined'
    end
    
    check.update_attributes(last_value: value)
    
    if current_state != last_state
      check.send("set_#{current_state}")
    end    
    
    check.schedule
  end
end
