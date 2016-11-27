
module Devices

  class HueControl

    def initialize()
      @client = Hue::Client.new()
    end

    def status(area)
      case area.downcase
      when 'outside'
        porch = self.light_status "Porch"
        data = { porch: porch }
      when 'entryway'
        entryway = self.light_status "Entryway"
        data = { entryway: entryway }
      when 'living room'
        living_room_table_lamp = self.light_status "Living Room Table Lamp"
        living_room_floor_lamp = self.light_status "Living Room Floor Lamp"
        data = { living_room_table_lamp: living_room_table_lamp, living_room_floor_lamp: living_room_floor_lamp }
      when 'dining room'
        cube = self.light_status "Cube Lamp"
        data = { cube: cube }
      when 'hallway'
        hallway = self.light_status "Hallway"
        data = { hallway: hallway }
      when 'study'
        study = self.light_status "Study"
        data = { study: study }
        # TODO How to deal with lamp swtich, not Hue?
      when 'bedroom'
        bedroom_lamp_christian = self.light_status "Bedroom Lamp, Christian"
        data = { bedroom_lamp_christian: bedroom_lamp_christian }
      when 'dressing room'
        rope_light = self.light_status "Rope Light"
        data =  { rope_light: rope_light }
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

    def turn_light_on(name, brightness=254, color_temperature=2300)
      light = self.light(name)
      if light
        light.on!
        light.set_state({ brightness: brightness, color_temperature: self.k_to_mired(color_temperature) }, 5)
      end
    end

    def turn_light_off(name)
      light = self.light(name)
      if light
        light.off!
      end
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
