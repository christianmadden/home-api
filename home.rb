
class Home

  def initialize()
    @smartthings = Devices::SmartThingsControl.new
    @hue = Devices::HueControl.new
    @nest = Devices::NestControl.new
    @sonos = Devices::SonosControl.new
    @store = Persist.new
  end

  def status
    return {
      smartthings: { mode: self.mode(), home: self.is_home?, away: self.is_away?, day: self.is_day?, night: self.is_night? }
    }
  end

  def execute_routine(routine, opts = {})
    if self.is_mode?(routine)
      self.set_mode(routine)
    end
    if opts[:execute_on_smart_things]
      @smartthings.exec(routine)
    end
    case routine
    when 'morning', 'daytime', 'morning-away', 'daytime-away', 'bedtime'
      @hue.turn_light_off("Living Room Front")
      @hue.turn_light_off("Living Room Rear")
      @hue.turn_light_off("Cube")
      @nest.home!
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

  def mode
    if mode = @store[:mode]
      mode
    else
      ""
    end
  end

  def set_mode(mode)
    @store[:mode] = mode
  end

  def is_mode?(routine)
    ['morning', 'morning-away', 'daytime', 'daytime-away', 'night', 'night-away', 'late-night', 'late-night-away', 'sleepy', 'bedtime'].include? routine
  end

  def is_home?
    !self.is_away?
  end

  def is_away?
    self.mode().include? 'away'
  end

  def is_night?
    self.mode().include? 'night' || mode == 'sleepy' || mode == 'bedtime'
  end

  def is_day?
    !self.is_night?
  end

  def set_temperature(device, temperature)
    @nest.set_temperature(device, temperature)
  end

  def commute_work_depart(person)
    @nest.home!
  end

  def commute_home_arrive(person)
    if self.is_night?
      @hue.turn_light_on("Porch", 254, 2700)
    end
  end

end
