
class Home

  def initialize()
    @smartthings = Devices::SmartThingsControl.new
    @hue = Devices::HueControl.new
    @nest = Devices::NestControl.new
  end

  def status
    return {
      smartthings: { presence: { home: @smartthings.home?, away: @smartthings.away? } },
      hue: { upstairs: @hue.status('Upstairs'), living_room_floor_lamp: @hue.status('Living Room Floor Lamp'), downstairs: @hue.status('Downstairs'), loft: @hue.status('Loft') },
      nest: { upstairs: @nest.status('Upstairs'), downstairs: @nest.status('Downstairs') },
    }
  end

  def execute_routine(routine)

    @smartthings.exec(routine)

    upstairs = @hue.group('Upstairs')
    living_room_floor_lamp = @hue.group('Living Room Floor Lamp')
    cats = @hue.group('Cats')
    case routine
    when 'morning', 'daytime', 'bedtime'
      @hue.turn_group_off(upstairs)
      @hue.turn_group_off(living_room_floor_lamp)
      @hue.turn_group_off(cats)
      @nest.home!
    when 'morning-away', 'daytime-away'
      @hue.turn_group_off(upstairs)
      @hue.turn_group_off(living_room_floor_lamp)
      @hue.turn_group_off(cats)
      @nest.away!
    when 'night-away', 'late-night-away'
      @hue.turn_group_off(upstairs)
      @hue.turn_group_off(living_room_floor_lamp)
      @hue.turn_group_on(cats, 128)
      @nest.away!
    when 'night'
      @hue.turn_group_on(upstairs)
      @hue.turn_group_on(living_room_floor_lamp, 254, 2700)
      @nest.home!
    when 'late-night'
      @hue.turn_group_on(upstairs, 128)
      @hue.turn_group_on(living_room_floor_lamp, 216, 2500)
      @nest.home!
    when 'sleepy'
      @hue.turn_group_on(upstairs, 32)
      @hue.turn_group_off(living_room_floor_lamp)
      @nest.home!
    when 'reading'
      @hue.turn_group_on(upstairs, 254, 4500)
      @hue.turn_group_on(living_room_floor_lamp, 254, 4500)
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

  def on_commute_left_work
    @nest.home!
  end

end
