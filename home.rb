
class Home

  @@HUE_ULTRA_WARM = 2100
  @@HUE_SUPER_WARM = 2200
  @@HUE_WARM = 2700
  @@HUE_NEUTRAL_WARM = 3100
  @@HUE_NEUTRAL = 4100
  @@HUE_COOL = 5000
  @@HUE_DAYLIGHT = 6500

  @@HUE_FULL_BRIGHTNESS = 255
  @@HUE_MODERATE_BRIGHTNESS = 192
  @@HUE_HALF_BRIGHTNESS = 128
  @@HUE_QUARTER_BRIGHTNESS = 64
  @@HUE_DIM_BRIGHTNESS = 32

  def initialize()
    @smartthings = Devices::SmartThingsControl.new
    @hue = Devices::HueControl.new
    @nest = Devices::NestControl.new
    @harmony = Devices::HarmonyControl.new
    @store = Persist.new
  end

  def status

    smartthings = { mode: self.mode(), home: self.is_home?, away: self.is_away?, day: self.is_day?, night: self.is_night? }
    #downstairs = { current_temperature: @nest.current_temperature("downstairs") }
    #upstairs = { current_temperature: @nest.current_temperature("upstairs") }

    return {
      smartthings: smartthings#,
      #nest:
      #{
      #  downstairs: downstairs,
      #  upstairs: upstairs
      #}
    }

  end

  def set_mode(mode, opts = {})

    if opts[:execute_on_smart_things]
      @smartthings.exec(mode)
    end

    store_mode(mode)

    case mode
    when 'morning', 'daytime', 'morning-away', 'daytime-away'
      @hue.off("Living Room Front")
      @hue.off("Living Room Rear")
      @hue.off("Cube")
      @hue.off("Porch")
      #@smartThings.switchOff("Porch Lights")
      @nest.home!
    when 'night-away'
      @hue.on("Living Room Front", @@HUE_HALF_BRIGHTNESS, @@HUE_SUPER_WARM )
      @hue.off("Living Room Rear")
      @hue.on("Cube", @@HUE_HALF_BRIGHTNESS, @@HUE_SUPER_WARM)
      @nest.away!
    when 'late-night-away'
      @hue.on("Living Room Front", @@HUE_QUARTER_BRIGHTNESS, @@HUE_ULTRA_WARM)
      @hue.off("Living Room Rear")
      @hue.on("Cube", @@HUE_QUARTER_BRIGHTNESS, @@HUE_ULTRA_WARM)
      @nest.away!
    when 'night'
      @hue.on("Living Room Front", @@HUE_FULL_BRIGHTNESS, @@HUE_WARM)
      @hue.on("Living Room Rear", @@HUE_FULL_BRIGHTNESS, @@HUE_WARM)
      @hue.on("Cube", @@HUE_FULL_BRIGHTNESS, @@HUE_WARM)
      @nest.home!
    when 'late-night'
      @hue.on("Living Room Front", @@HUE_HALF_BRIGHTNESS, @@HUE_SUPER_WARM)
      @hue.on("Living Room Rear", @@HUE_HALF_BRIGHTNESS, @@HUE_SUPER_WARM)
      @hue.on("Cube", @@HUE_HALF_BRIGHTNESS, @@HUE_SUPER_WARM)
      @nest.home!
    when 'sleepy'
      @hue.on("Living Room Front", @@HUE_DIM_BRIGHTNESS, @@HUE_ULTRA_WARM)
      @hue.off("Living Room Rear")
      @hue.on("Cube", @@HUE_DIM_BRIGHTNESS, @@HUE_ULTRA_WARM)
      @nest.home!
    when 'bedtime'
      @hue.off("Living Room Front")
      @hue.off("Living Room Rear")
      @hue.off("Cube")
      @hue.off("Porch")
      @nest.home!
      self.harmony_off()
    end

  end

  def activity(activity, opts = {})

    case activity
    when 'reading'
      @hue.on("Living Room Front", @@HUE_FULL_BRIGHTNESS, @@HUE_NEUTRAL_WARM)
      @hue.on("Living Room Rear", @@HUE_FULL_BRIGHTNESS, @@HUE_NEUTRAL_WARM)
    when 'apple-tv', 'watch-tv', 'tv'
      @harmony.activity(activity)
    when 'ps4', 'playstation'
      @harmony.activity(activity)
    when 'xbox'
      @harmony.activity(activity)
    when 'switch', 'nintendo'
      @harmony.activity(activity)
    when 'shutdown'
      self.harmony_off()
    end

  end

  def mode
    if mode = @store[:mode]
      mode
    else
      ""
    end
  end

  def store_mode(mode)
    @store[:mode] = mode
  end

  def is_home?
    !self.is_away?
  end

  def is_away?
    self.mode().include? 'away'
  end

  def is_night?
    self.mode().include? 'night'
  end

  def is_day?
    !self.is_night?
  end

  #def set_light(name, action)
  #  
  #end

  def set_thermostat(location, temperature)
    @nest.set_temperature(location, temperature)
  end

  def set_thermostat_presence(location, presence)
    if presence == "away" || presence == "eco"
      @nest.away!
    elsif presence == "home"
      @nest.home!
    end
  end

  # Tell Nest that I am home when I leave work so that the house is warm when I actually get home
  def car_left_work(car)
    @nest.home!
  end

  # When I get home, turn on the porch light if it's night
  def car_arrived_home(car)
    if self.is_night?
      @hue.on("Porch", @@HUE_FULL_BRIGHTNESS , @@HUE_WARM)
    end
  end

  # Harmony
  def harmony_off()
    @harmony.off()
  end

  def harmony_play(device)
    @harmony.play(device)
  end

  def harmony_pause(device)
    @harmony.pause(device)
  end

  def harmony_mute()
    @harmony.mute()
  end

  def harmony_activity(activity)
    @harmony.activity(activity)
  end

end
