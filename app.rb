
# TODO: Harmony
# TODO: Automatic
# TODO: Caseta
# TODO: Sonos
# TODO: Look into speaking commands to Alexa via text-to-speech (control Sonos from basement Dot?)

class App < Sinatra::Base

  register Sinatra::Namespace

  def initialize()
    @home = Home.new
    super()
  end

  configure do
    enable :logging
    file = File.new("#{settings.root}/log/#{settings.environment}-log.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end

  register do
    def auth(require_auth)
        condition do
            error 401 unless params[:key] == ENV['HOME_API_KEY']
        end
    end
  end

  get '/' do
    'Hi.'
  end

  namespace '/api/:key' do

    get '/status', :auth => true do
      logger.info "STATUS: #{@home.status}"
      { status: 'success', data: @home.status }.to_json
    end

    # Switch house to mode and optionally execute matching SmartThings routine
    get '/mode/:name', :auth => true do
      mode = params[:name]
      logger.info "MODE: #{mode}"
      @home.set_mode(mode, { execute_on_smart_things: true })
      { status: 'success', data: { mode: mode } }.to_json
    end

    get '/mode/:name/smartthings/:execute_on_smart_things', :auth => true do
      mode = params[:name]
      execute_on_smart_things = params[:execute_on_smart_things] == "true" ? true : false
      logger.info "MODE: #{mode}, exec on ST #{execute_on_smart_things}"
      @home.set_mode(mode, { execute_on_smart_things: execute_on_smart_things })
      { status: 'success', data: { mode: mode } }.to_json
    end

    # Perform activity
    get '/activity/:name', :auth => true do
      activity = params[:name]
      logger.info "ACTIVITY: #{activity}"
      @home.activity(activity)
      { status: 'success', data: { activity: activity } }.to_json
    end

    # Turn individual lights on or off
    #get '/light/:name/:action', :auth => true do
    #  name = params[:name]
    #  action = params[:action]
    #  logger.info "LIGHT: #{name} set to #{action}"
    #  @home.setLight(name, action)
    #  { status: 'success', message: "Light #{name} set to #{action}", data: { name: name, action: action } }.to_json
    #end

    # Set thermostat to temp
    get '/thermostat/:location/:temperature', :auth => true do
      location = params[:location]
      temperature = params[:temperature]
      logger.info "THERMOSTAT SET: #{location} set to #{temperature}"
      #@home.setThermostat(location, temperature)
      { status: 'success', message: "Thermostat #{location} set to #{temperature}", data: { location: location, temperature: temperature } }.to_json
    end

    # Set thermostat presence to Home or Away/Eco
    get '/thermostat/:location/:presence', :auth => true do
      location = params[:location]
      presence = params[:presence]
      logger.info "THERMOSTAT PRESENCE: " + presence
      @home.setThermostatPresence(location, presence)
      { status: 'success', message: "Thermostat #{presence} set to #{presence}", data: { location: location, presence: presence } }.to_json
    end

    # Car has arrived or left location
    get '/car/:car/:location/:event', :auth => true do
      car = params[:car]
      location = params[:location]
      event = params[:event]
      logger.info "CAR: #{car} #{event} from #{location}"
      if car.include? "audi" and location.include? "work" and event.include? "depart"
        @home.car_left_work(car)
      elsif car.include? "audi" and location.include? "home" and event.include? "arrive"
        @home.car_arrived_home(car)
      end
      { status: 'success', message: "#{car} #{event} from #{location}", data: { car: car, location: location, event: event } }.to_json
    end

    # Harmony functions
    get '/harmony/off', :auth => true do
      logger.info "HARMONY: off"
      @home.harmony_off()
      { status: 'success', message: "Harmony off", data: {} }.to_json
    end

    get '/harmony/:device/play', :auth => true do
      device = params[:device]
      logger.info "HARMONY: play"
      @home.harmony_play(device)
      { status: 'success', message: "Harmony play", data: { device: device } }.to_json
    end

    get '/harmony/:device/pause', :auth => true do
      device = params[:device]
      logger.info "HARMONY: pause"
      @home.harmony_pause(device)
      { status: 'success', message: "Harmony pause", data: { device: device } }.to_json
    end

    get '/harmony/mute', :auth => true do
      logger.info "HARMONY: mute"
      @home.harmony_mute()
      { status: 'success', message: "Harmony mute", data: {} }.to_json
    end

    get '/harmony/:activity', :auth => true do
      activity = params[:activity]
      logger.info "HARMONY: #{activity} ON"
      @home.harmony_activity(activity)
      { status: 'success', message: "HARMONY: #{activity} ON", data: { activity: activity } }.to_json
    end

  end

end
