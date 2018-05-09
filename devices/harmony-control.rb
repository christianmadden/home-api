
module Devices

  class HarmonyControl

    def initialize()
      @endpoint_url = ENV['HARMONY_ENDPOINT_BASE_URL']
      @hub_name = ENV['HARMONY_HUB_NAME']
      @volume_device = ENV['HARMONY_VOLUME_DEVICE']
    end

    def post(path)
      response = HTTParty.post("#{@endpoint_url}/hubs/#{@hub_name}" + path, {})
    end

    # Turn off system
    def off()
      self.post("/activities/poweroff")
    end

    # Toggles mute on and off. Doesn't track state.
    def mute()
      self.post("/devices/#{@volume_device}/commands/mute")
    end

    # Mute and unmute are the same. Could check status first to make these not just a toggle.
    def unmute()
      self.mute()
    end

    # Turn on activity
    def activity(name)
      self.post("/activities/#{name}")
    end

  end

end
