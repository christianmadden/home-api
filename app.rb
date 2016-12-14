
class App < Sinatra::Base

  register Sinatra::Namespace

  def initialize()
    @home = Home.new
    @store = Persist.new
    super()
  end

  get '/' do
    %(<a href="/api/status">status</a>)
  end

  namespace '/api' do

    get '/status' do
      { status: 'success', data: @home.status }.to_json
    end

    # Execute routine triggered by IFTTT
    get '/ifttt/:name' do
      routine = params[:name]
      if ['morning', 'morning-away', 'daytime', 'daytime-away', 'night', 'night-away', 'late-night', 'late-night-away', 'sleepy', 'bedtime'].include? routine
        @store[:mode] = routine
      end
      @home.execute_routine(routine, { execute_on_smart_things: true })
      { status: 'success', data: { routine: routine, mode: @store[:mode] } }.to_json
    end

    # Execute routine triggered by SmartThings
    get '/routine/:name' do
      routine = params[:name]
      if ['morning', 'morning-away', 'daytime', 'daytime-away', 'night', 'night-away', 'late-night', 'late-night-away', 'sleepy', 'bedtime'].include? routine
        @store[:mode] = routine
      end
      @home.execute_routine(routine, { execute_on_smart_things: false })
      { status: 'success', data: { routine: routine, mode: @store[:mode] } }.to_json
    end

    get '/temperature/:device/:temperature' do
      device = params[:device]
      temperature = params[:temperature]
      @home.set_temperature(device, temperature)
      { status: 'success', message: "Temperature for #{device} set to mode: #{temperature}.", data: { device: device, temperature: temperature } }.to_json
    end

    get '/commute/work/depart/:person' do
      @home.commute_work_depart(params[:person], @store[:mode])
      { status: 'success', message: "Departed work", data: { person: params[:person], mode: @store[:mode] } }.to_json
    end

    get '/commute/work/arrive/:person' do
      { status: 'noop' }
    end

    get '/commute/home/depart/:person' do
      { status: 'noop' }
    end

    get '/commute/home/arrive/:person' do
      @home.commute_home_arrive(params[:person], @store[:mode])
      { status: 'success', message: "Arrived home.", data: { person: params[:person], mode: @store[:mode] } }.to_json
    end

  end

end
