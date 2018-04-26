
# TODO: Be able to check status.last_routine to make sure I'm not doubling (add endpoint to smartapp)

module Devices

  class SmartThingsControl

    def initialize()
      @access_token = ENV['ST_ACCESS_TOKEN']
      @endpoint_url = ENV['ST_ENDPOINT_BASE_URL']
    end

    def exec(routine)
      @routine = routine
      response = HTTParty.post(@endpoint_url + '/routine/' + @routine, :headers => { 'Authorization' => 'Bearer ' + @access_token })
    end

    def on
      
    end

  end

end
