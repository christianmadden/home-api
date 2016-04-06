
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
      { status: 'OK', message: 'HomeAPI is operational.' }.to_json
    end

    get '/api/mode/:mode' do
      mode = params[:mode]
      @home.on_mode_change(mode)
      { status: 'OK', message: "Changed to mode: #{mode}." }.to_json
    end

    get '/api/commute/work/depart' do
      @home.on_commute_left_work
      { status: 'OK', message: 'Commute start' }.to_json
    end

end
