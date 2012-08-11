require 'tinder'

class CampfireWorker
  include Sidekiq::Worker

  def perform(result)
    check = Check.find(result['check_id'])
    metric = result['metric']
    from = result['from'].to_s.upcase
    to = result['to'].to_s.upcase
    value = result['value']
    
    campfire = Tinder::Campfire.new(Rorschach::Config.campfire_account, ssl: true, token: Rorschach::Config.campfire_token)
    room = campfire.find_room_by_id(Rorschach::Config.campfire_room.to_i)
    
    message = "#{to}: value of #{metric} is #{value} (was #{from})"
    room.speak(message)
  end
  
end
