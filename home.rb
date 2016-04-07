
class Home

  def initialize(options)
    self.initialize_hue(options)
    self.initialize_nest(options)
  end

  def initialize_hue(options)
    @hue = Hue::Client.new()
  end

  def initialize_nest(options)
    config = {
      email: options[:nest_email],
      password: options[:nest_password],
      temperature_scale: :fahrenheit
    }
    @nest = NestThermostat::Nest.new(config)
    @nest.set_default_structure
    @nest.set_default_device
  end

  def status
    mode = self.mode
    away = mode.include? "away"
    return {
      smartthings: { mode: self.mode, presence: { home: !away, away: away } },
      nest: { upstairs: self.nest_status('Upstairs'), downstairs: self.nest_status('Downstairs') },
      hue: self.hue_status
    }
  end

  def nest_status(device_name)
    device_name.capitalize!
    @nest.set_device device_name
    return {
      away: @nest.away?,
      current_temperature: @nest.current_temperature.round(1),
      target_temperature: @nest.temperature.round(1),
      humidity: @nest.humidity,
      leaf: @nest.leaf?
    }
  end

  def hue_status()
    cube = self.light_status "Cube Lamp"
    living_room = self.light_status "Living Room Lamp"
    dining_room = self.light_status "Dining Room Lamp"
    loft_left = self.light_status "Loft Left"
    loft_right = self.light_status "Loft Right"
    bedroom = self.light_status "Bedroom Lamp, Christian"
    upstairs = { cube: cube, living_room: living_room, dining_room: dining_room }
    loft =  { loft_left: loft_left, loft_right: loft_right }
    downstairs = {  bedroom: bedroom }
    return { upstairs: upstairs, loft: loft, downstairs: downstairs }
  end

  def light_status(light_name)
    light = self.hue_light(light_name)
    { name: light_name, on: light.on?, hue: light.hue, brightness: light.brightness, color_temperature: self.mired_to_k(light.color_temperature) }
  end

  def on_mode_change(mode)
    @upstairs = self.hue_group('Upstairs')
    @cats = self.hue_group('Cats')
    case mode
    when 'morning', 'daytime', 'bedtime'
      self.hue_group_off(@upstairs)
      self.hue_group_off(@cats)
      self.nest_home
    when 'morning-away', 'daytime-away'
      self.hue_group_off(@upstairs)
      self.hue_group_off(@cats)
      self.nest_away
    when 'night-away', 'late-night-away'
      self.hue_group_off(@upstairs)
      self.hue_group_on(@cats, 128)
      self.nest_away
    when 'night'
      self.hue_group_on(@upstairs)
      self.nest_home
    when 'late-night'
      self.hue_group_on(@upstairs, 128)
      self.nest_home
    when 'sleepy'
      self.hue_group_on(@upstairs, 32)
      self.nest_home
    when 'movie'
      self.hue_group_on(@upstairs, 64)
      self.nest_home
    when 'reading'
      self.hue_group_on(@upstairs, 254, 4500)
      self.nest_home
    end
    self.save_mode mode
  end

  def on_temperature_change(device_name, temp)
    device_name.capitalize!
    @nest.set_device device_name
    @nest.temperature = temp
  end

  def on_commute_left_work
    self.nest_home
  end

  def hue_group(name)
    (@hue.groups.select { |group| group.name == name }).first
  end

  def hue_light(name)
    (@hue.lights.select { |light| light.name == name }).first
  end

  def hue_group_on(group, brightness=254, color_temperature=2300)
    group.lights.each do |light|
      light.on!
      light.set_state({ brightness: brightness, color_temperature: self.k_to_mired(color_temperature) }, 5)
    end
  end

  def hue_group_off(group)
    group.lights.each do |light|
      light.off!
    end
  end

  def k_to_mired(k)
    (1000000 / k).round
  end

  def mired_to_k(m)
    ((1.0/m) * 1000000).round
  end

  def nest_away
    # TODO Turn this back on when presence sensors are sorted out (new batteries)
    #@nest.away = true
  end

  def nest_home
    @nest.away = false
  end

  def save_mode(mode)
    File.open('.mode', 'w') do |f|
      f.write mode
    end
  end

  def mode
    mode =  'unknown'
    File.open('.mode', 'r') do |f|
      f.each_line do |line|
        mode = line
      end
    end
    mode
  end

end
