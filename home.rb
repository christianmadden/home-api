
class Home

  def initialize()
    @smartthings = Devices::SmartThingsControl.new
    @hue = Devices::HueControl.new
    @nest = Devices::NestControl.new
  end

  def status
    return {
      status: { status: "status" }
      #smartthings: { presence: { home: @smartthings.home?, away: @smartthings.away? } },
      #hue: { status: "status" },
      #nest: { upstairs: @nest.status('Upstairs'), downstairs: @nest.status('Downstairs') },
    }
  end

  def execute_routine(routine, opts)
    if opts[:execute_on_smart_things]
      #@smartthings.exec(routine)
    end
    case routine
    when 'morning', 'daytime', 'bedtime',
      @hue.turn_light_off("Living Room Front")
      @hue.turn_light_off("Living Room Rear")
      @hue.turn_light_off("Cube")
      @nest.home!
    when 'morning-away', 'daytime-away'
      @hue.turn_light_off("Living Room Front")
      @hue.turn_light_off("Living Room Rear")
      @hue.turn_light_off("Cube")
      @nest.away!
    when 'night-away'
      @hue.turn_light_on("Living Room Front", 128, 2200)
      @hue.turn_light_off("Living Room Rear")
      @hue.turn_light_on("Cube", 128, 2200)
      @nest.away!
    when 'late-night-away'
      @hue.turn_light_on("Living Room Front", 64, 2100)
      @hue.turn_light_off("Living Room Rear")
      @hue.turn_light_on("Cube", 64, 2100)
      @nest.away!
    when 'night'
      @hue.turn_light_on("Living Room Front", 254, 2700)
      @hue.turn_light_on("Living Room Rear", 254, 2700)
      @hue.turn_light_on("Cube", 254, 2700)
      @nest.home!
    when 'late-night'
      @hue.turn_light_on("Living Room Front", 128, 2200)
      @hue.turn_light_on("Living Room Rear", 128, 2200)
      @hue.turn_light_on("Cube", 128, 2200)
      @nest.home!
    when 'sleepy'
      @hue.turn_light_on("Living Room Front", 38, 2100)
      @hue.turn_light_off("Living Room Rear")
      @hue.turn_light_on("Cube", 38, 2100)
      @nest.home!
    when 'reading'
      @hue.turn_light_on("Living Room Front", 254, 4500)
      @hue.turn_light_on("Living Room Rear", 254, 4500)
      @nest.home!
    when 'tivo'
      @nest.home!
    when 'appletv'
      @nest.home!
    when 'playstation'
      @nest.home!
    when 'xbox'
      @nest.home!
    when 'turntable'
      @nest.home!
    when 'shutdown'
      @nest.home!
    end
  end

  def set_temperature(device, temperature)
    @nest.set_temperature(device, temperature)
  end

  def commute_work_depart(person, mode)
    @nest.home!
  end

  def commute_home_arrive(person, mode)
    if ['night', 'night-away', 'late-night', 'late-night-away', 'sleepy'].include? mode
      @hue.turn_light_on("Porch", 254, 2700)
    end
  end

end
