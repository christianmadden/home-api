
class App < Sinatra::Base

  register Sinatra::Namespace

  def initialize()
    @home = Home.new
    super()
  end

  configure do
    enable :logging
    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
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
      { status: 'success', data: @home.status }.to_json
    end

    # Execute routine triggered by IFTTT
    get '/ifttt/:name' do
      routine = params[:name]
      logger.info "IFTTT: " + routine
      @home.execute_routine(routine, { execute_on_smart_things: true })
      { status: 'success', data: { routine: routine, mode: @home.mode() } }.to_json
    end

    # Execute routine triggered by SmartThings
    get '/routine/:name' do
      routine = params[:name]
      logger.info "ST: " + routine
      @home.execute_routine(routine, { execute_on_smart_things: false })
      { status: 'success', data: { routine: routine, mode: @home.mode() } }.to_json
    end

    get '/temperature/:device/:temperature' do
      device = params[:device]
      temperature = params[:temperature]
      @home.set_temperature(device, temperature)
      { status: 'success', message: "Temperature for #{device} set to mode: #{temperature}.", data: { device: device, temperature: temperature } }.to_json
    end

    get '/commute/work/depart/:person' do
      @home.commute_work_depart(params[:person])
      { status: 'success', message: "Departed work", data: { person: params[:person] } }.to_json
    end

    get '/commute/work/arrive/:person' do
      { status: 'noop' }
    end

    get '/commute/home/depart/:person' do
      { status: 'noop' }
    end

    get '/commute/home/arrive/:person' do
      @home.commute_home_arrive(params[:person])
      { status: 'success', message: "Arrived home.", data: { person: params[:person] } }.to_json
    end

  end

end
