
# TODO Define API
# TODO Slackbot? SMS? Alfred?
# TODO Dash button (sleep, Netflix)
# TODO Homekit/Siri (through Node app)
# TODO Amazon Echo
# TODO Automatic for S4
# TODO Harmony? Through Smartthings?

class App < Sinatra::Base

    def initialize
      options = {}
      options[:nest_email] = ENV['NEST_EMAIL']
      options[:nest_password] = ENV['NEST_PASSWORD']
      @home = Home.new options
      super()
    end

    get '/api/status' do
      status = @home.status
      { code: 'OK', message: 'HomeAPI is up and running.', status: status }.to_json
    end

    get '/api/mode/:mode' do
      mode = params[:mode]
      @home.on_mode_change(mode)
      { code: 'OK', message: "Changed to mode: #{mode}." }.to_json
    end

    get '/api/temperature/:device_name/:temp' do
      device_name = params[:device_name]
      temp = params[:temp]
      @home.on_temperature_change(device_name, temp)
      { code: 'OK', message: "Temperature for #{device_name} set to mode: #{temp}." }.to_json
    end

    get '/api/commute/work/depart' do
      @home.on_commute_left_work
      { code: 'OK', message: 'Commute started.' }.to_json
    end

end
