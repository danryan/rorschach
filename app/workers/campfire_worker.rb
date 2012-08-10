require 'tinder'

class CampfireWorker
  include Sidekiq::Worker

  def perform(results)
    check = Check.find(results['check_id'])
    incident_key = results['metric']
    state = results['state'].to_s.upcase
    value = results['value']
    
    campfire = Tinder::Campfire.new(Rorschach::Config.campfire_account, ssl: true, token: Rorschach::Config.campfire_token)
    
    room = campfire.find_room_by_id(Rorschach::Config.campfire_room.to_i)
    
    room.speak("#{incident_key} - #{state.to_s.upcase}: value of #{value}")
  end
  
end
