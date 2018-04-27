
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

    def current_temperature(name)
      @client.set_device(name.capitalize)
      @client.current_temperature.round(0)
    end

    def target_temperature(name)
      @client.set_device(name.capitalize)
      @client.temperature.round(0)
    end

    def humidity(name)
      @client.set_device(name.capitalize)
      @client.humidity.round(0)
    end

    def away(name)
      @client.set_device(name.capitalize)
      @client.away?
    end

    def home(name)
      !away(name)
    end

    def leaf(name)
      @client.set_device(name.capitalize)
      @client.leaf?
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
