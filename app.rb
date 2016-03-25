
class App < Sinatra::Base

    nest = NestThermostat::Nest.new(email: ENV['NEST_EMAIL'], password: ENV['NEST_PASSWORD'])

    get '/' do
        up = nest.status["shared"][ENV['NEST_UPSTAIRS_SERIAL']]
        down = nest.status["shared"][ENV['NEST_DOWNSTAIRS_SERIAL']]
        "Upstairs: #{up["current_temperature"]}°/#{up["target_temperature"]}° | Downstairs: #{down["current_temperature"]}°/#{down["target_temperature"]}°"
    end

    get '/status' do
      "#{nest.status["shared"][ENV['NEST_UPSTAIRS_SERIAL']]}"
    end

end
