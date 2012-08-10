class CheckWorker
  include Sidekiq::Worker

  def perform(options={})
    metric = options['metric']
    value = options['value'].to_f
    warning = options['warning'].to_f
    critical = options['critical'].to_f
    
    if critical > warning
      if value >= critical
        Rails.logger.error "CRITICAL", :metric => metric, :status => "CRITICAL", :value => value
      elsif value >= warning
        Rails.logger.warn "WARNING", :metric => metric, :status => "WARNING", :value => value
      else
        Rails.logger.info "OK", :metric => metric, :status => "OK", :value => value
      end
    else
      if value <= critical
        Rails.logger.error "CRITICAL", :metric => metric, :status => "CRITICAL", :value => value
        
      elsif value <= warning
        Rails.logger.warn "WARNING", :metric => metric, :status => "WARNING", :value => value
      else
        Rails.logger.info "OK", :metric => metric, :status => "OK", :value => value
      end
    end
    
    self.class.perform_in(options[:interval], options)
  end
end
