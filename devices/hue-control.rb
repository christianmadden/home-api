
module Devices

  class HueControl

    def initialize()
      @client = Hue::Client.new()
    end

    def status(name)
      light = self.light(name)
      if light
        { name: name, on: light.on?, hue: light.hue, brightness: light.brightness, color_temperature: self.mired_to_k(light.color_temperature) }
      end
    end

    def light(name)
      (@client.lights.select { |light| light.name == name }).first
    end

    def on(name, brightness=254, color_temperature=2300)
      light = self.light(name)
      if light
        light.on!
        light.set_state({ brightness: brightness, color_temperature: self.k_to_mired(color_temperature) }, 5)
      end
    end

    def off(name)
      light = self.light(name)
      if light
        light.off!
      end
    end

    def group(name)
      (@client.groups.select { |group| group.name == name }).first
    end

    def group_on(group, brightness=254, color_temperature=2300)
      group.lights.each do |light|
        light.on!
        light.set_state({ brightness: brightness, color_temperature: self.k_to_mired(color_temperature) }, 5)
      end
    end

    def group_off(group)
      group.lights.each do |light|
        light.off!
      end
    end

    def k_to_mired(k)
      if k > 0
        (1000000 / k).round
      else
        0
      end
    end

    def mired_to_k(m)
      if m > 0
        ((1.0/m) * 1000000).round
      else
        0
      end
    end

  end

end
