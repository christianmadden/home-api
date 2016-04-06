
class Home

  def initialize(options)
    self.initialize_hue(options)
    self.initialize_nest(options)
  end

  def initialize_hue(options)
    @hue = Hue::Client.new()
    @upstairs = self.find_hue_group_by_name('Upstairs')
    @cats = self.find_hue_group_by_name('Cats')
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

  def on_mode_change(mode)
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
      self.hue_group_on(@cats)
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
  end

  def on_commute_left_work
    self.nest_home
  end

  def find_hue_group_by_name(name)
    (@hue.groups.select { |group| group.name == name }).first
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

  def nest_away
    # TODO Turn this back on when presence sensors are sorted out (new batteries)
    #@nest.away = true
  end

  def nest_home
    @nest.away = false
  end

end
