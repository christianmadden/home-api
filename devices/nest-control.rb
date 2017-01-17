
module Devices

  class NestControl

    def initialize()
      config = {
        email: ENV['NEST_EMAIL'],
        password: ENV['NEST_PASSWORD'],
        temperature_scale: :fahrenheit
      }
      @client = NestThermostat::Nest.new(config)
      @client.set_default_structure
    end

    def status(name)
      @client.set_device(name.capitalize)
      return {
        away: @client.away?,
        current_temperature: @client.current_temperature.round(1),
        target_temperature: @client.temperature.round(1),
        humidity: @client.humidity,
        leaf: @client.leaf?
      }
    end

    def set_temperature(device, temperature)
      @client.set_device(device.capitalize)
      @client.temperature = temperature
    end

    def away!
      @client.away = true
    end

    def home!
      @client.away = false
    end

  end

end
