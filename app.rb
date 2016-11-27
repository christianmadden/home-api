
# TODO Dash button (sleep, Netflix)
# TODO Amazon Echo
# TODO Automatic Pro for S4

class App < Sinatra::Base

  register Sinatra::Namespace

  def initialize()
    @home = Home.new
    super()
  end

  get '/' do
    %(<a href="/api/status">status</a>)
  end

  namespace '/api' do

    get '/status' do
      { status: 'success', data: @home.status }.to_json
    end

    # Execute routine
    get '/routine/:name' do
      routine = params[:name]
      @home.execute_routine(routine)
      { status: 'success', data: { routine: routine } }.to_json
    end

    get '/temperature/:device/:temperature' do
      device = params[:device]
      temperature = params[:temperature]
      @home.set_temperature(device, temperature)
      { status: 'success', message: "Temperature for #{device} set to mode: #{temperature}.", data: { device: device, temperature: temperature } }.to_json
    end

    get '/commute/on/depart/work' do
      @home.on_commute_left_work
      { status: 'success', message: "Commute started.", data: {} }.to_json
    end

    get '/commute/on/arrive/home' do
      @home.on_commute_arrive_home
      { status: 'success', message: "Arrived home.", data: {} }.to_json
    end

  end

end
