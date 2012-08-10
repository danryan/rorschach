# blatantly stolen with love from https://github.com/heroku/umpire
module Rorschach
  module Config
    def self.env!(k)
      ENV[k] || raise("missing key #{k}")
    end

    # def self.deploy; env!("DEPLOY"); end
    def self.graphite_url; env!("GRAPHITE_URL"); end
    def self.graphite_auth; ENV['GRAPHITE_AUTH']; end

    # Campfire variables
    def self.campfire_account; env!('CAMPFIRE_ACCOUNT'); end
    def self.campfire_token; env!('CAMPFIRE_TOKEN'); end
    def self.campfire_room; env!('CAMPFIRE_ROOM'); end

    # PagerDuty variables
    def self.pagerduty_api_key; env!('PAGERDUTY_API_KEY'); end

    # def self.force_https?; env!("FORCE_HTTPS") == "true"; end
    # def self.api_key; env!("API_KEY"); end
  end
end
