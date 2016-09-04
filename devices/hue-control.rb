
module Devices

  class HueControl

    def initialize()
      @client = Hue::Client.new()
    end

    def status(area)
      case area.downcase
      when 'upstairs'
        cube = self.light_status "Cube Lamp"
        living_room = self.light_status "Living Room Lamp"
        dining_room = self.light_status "Dining Room Lamp"
        data = { cube: cube, living_room: living_room, dining_room: dining_room }
      when 'living room floor lamp'
        living_room_floor_lamp = self.light_status "Living Room Floor Lamp"
        data = { living_room_floor_lamp: living_room_floor_lamp }
      when 'downstairs'
        bedroom = self.light_status "Bedroom Lamp, Christian"
        data = { bedroom: bedroom }
      when 'loft'
        loft_left = self.light_status "Loft Left"
        loft_right = self.light_status "Loft Right"
        data =  { loft_left: loft_left, loft_right: loft_right }
      end
      return data
    end

    def light_status(name)
      light = self.light(name)
      if light
        { name: name, on: light.on?, hue: light.hue, brightness: light.brightness, color_temperature: self.mired_to_k(light.color_temperature) }
      end
    end

    def light(name)
      (@client.lights.select { |light| light.name == name }).first
    end

    def group(name)
      (@client.groups.select { |group| group.name == name }).first
    end

    def turn_group_on(group, brightness=254, color_temperature=2300)
      group.lights.each do |light|
        light.on!
        light.set_state({ brightness: brightness, color_temperature: self.k_to_mired(color_temperature) }, 5)
      end
    end

    def turn_group_off(group)
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
