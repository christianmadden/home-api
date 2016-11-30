
class Home

  def initialize()
    @smartthings = Devices::SmartThingsControl.new
    @hue = Devices::HueControl.new
    #@nest = Devices::NestControl.new
  end

  def status
    return {
      status: { status: "status" }
      #smartthings: { presence: { home: @smartthings.home?, away: @smartthings.away? } },
      #hue: { status: "status" },
      #nest: { upstairs: @nest.status('Upstairs'), downstairs: @nest.status('Downstairs') },
    }
  end

  def execute_routine(routine)

    @smartthings.exec(routine)
    case routine
    when 'morning', 'daytime', 'bedtime',
      @hue.turn_light_off("Porch")
      @hue.turn_light_off("Entryway")
      @hue.turn_light_off("Living Room Floor Lamp")
      @hue.turn_light_off("Living Room Table Lamp")
      @hue.turn_light_off("Cube Lamp")
      @hue.turn_light_off("Hallway")
      @hue.turn_light_off("Study")
      @hue.turn_light_off("Bedroom Lamp, Christian")
      @hue.turn_light_off("Rope Light")
      #@nest.home!
    when 'morning-away', 'daytime-away'
      @hue.turn_light_off("Porch")
      @hue.turn_light_off("Entryway")
      @hue.turn_light_off("Living Room Floor Lamp")
      @hue.turn_light_off("Living Room Table Lamp")
      @hue.turn_light_off("Cube Lamp")
      @hue.turn_light_off("Hallway")
      @hue.turn_light_off("Study")
      @hue.turn_light_off("Bedroom Lamp, Christian")
      @hue.turn_light_off("Rope Light")
      #@nest.away!
    when 'night-away', 'late-night-away'
      @hue.turn_light_off("Porch")
      @hue.turn_light_off("Entryway")
      @hue.turn_light_on("Living Room Floor Lamp", 128, 2500)
      @hue.turn_light_off("Living Room Table Lamp")
      @hue.turn_light_on("Cube Lamp", 128, 2500)
      @hue.turn_light_on("Hallway", 64, 2300)
      @hue.turn_light_off("Study")
      @hue.turn_light_off("Bedroom Lamp, Christian")
      @hue.turn_light_off("Rope Light")
      #@nest.away!
    when 'night'
      @hue.turn_light_on("Entryway", 216, 2500)
      @hue.turn_light_on("Living Room Floor Lamp", 254, 2700)
      @hue.turn_light_on("Living Room Table Lamp", 254, 2700)
      @hue.turn_light_on("Cube Lamp", 254, 2700)
      @hue.turn_light_on("Hallway", 216, 2500)
      #@nest.home!
    when 'late-night'
      @hue.turn_light_on("Entryway", 128, 2400)
      @hue.turn_light_on("Living Room Floor Lamp", 216, 2500)
      @hue.turn_light_on("Living Room Table Lamp", 216, 2500)
      @hue.turn_light_on("Cube Lamp", 216, 2500)
      @hue.turn_light_off("Hallway")
      #@nest.home!
    when 'sleepy'
      @hue.turn_light_off("Entryway")
      @hue.turn_light_on("Living Room Floor Lamp", 64, 2200)
      @hue.turn_light_off("Living Room Table Lamp")
      @hue.turn_light_on("Cube Lamp", 64, 2200)
      @hue.turn_light_off("Hallway")
      #@nest.home!
    when 'reading'
      @hue.turn_light_on("Living Room Floor Lamp", 254, 4500)
      @hue.turn_light_on("Living Room Table Lamp", 254, 4500)
      #@nest.home!
    when 'tivo'
      True
      #@nest.home!
    when 'appletv'
      True
      #@nest.home!
    when 'playstation'
      True
      #@nest.home!
    when 'xbox'
      True
      #@nest.home!
    when 'turntable'
      True
      #@nest.home!
    when 'shutdown'
      True
      #@nest.home!
    end
  end

  def set_temperature(device, temperature)
    #@nest.set_temperature(device, temperature)
  end

  def on_commute_left_work
    #@nest.home!
  end

  def on_commute_arrive_home
    # TODO Turn on porch light if night, etc.
  end

end
