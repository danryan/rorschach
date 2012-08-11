class Event
  attr_accessor :check_id, :metric, :value, :from, :to
  
  def initialize(options={})
    @check_id = options['check_id']
    @metric = options['metric']
    @value = options['value']
    @from = options['from']
    @to = options['to']
  end
  
end