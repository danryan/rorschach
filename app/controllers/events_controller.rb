class EventsController < ApplicationController
  def index
    results = Rorschach.redis {|c| c.lrange("events", 0, 99)}.map {|e| JSON.parse(e)}
    
    @events = results.map do |event|
      Event.new(event)
    end
  end
end
