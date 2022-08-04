require 'sinatra'
require 'active_record'
require 'json'

require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
require 'opentelemetry/instrumentation/all'

OpenTelemetry::SDK.configure do |c|
    c.use_all() # enables all instrumentation!
end

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "127.0.0.1",
  :port     => "3308",
  :username => "root",
  :password => "example",
  :database => "plants"
)

class Plant < ActiveRecord::Base

end

begin
    ActiveRecord::Migration.create_table :plant do |t|
        t.string :name
end
rescue
    puts("Plants table already exists")
end

class App < Sinatra::Application
end

before do
    content_type :json
end

get '/plants/:id' do |plantId|
    current_span = OpenTelemetry::Trace.current_span
    current_span.set_attribute("plant.id", plantId)

    plant = Plant.find_by(id: plantId)     

    plant.to_json
end

get '/plants' do
    allPlants = []

    tracer = OpenTelemetry.tracer_provider.tracer('plant-tracer')
    tracer.in_span("list-plants") do |span|
        span.add_event("This is going to run the query, right?")
        allPlants = Plant.all
        span.add_event("Maybe the query ran?")
        span.set_attribute('plants.all', true)
    end

    tracer.in_span("all-plants-to-json") do |span|
        allPlants.to_json
    end
end

post '/plants' do
    plantData = JSON.parse request.body.read
    plantName = plantData['name']

    plant = Plant.create(name: plantName)
    
    plant.to_json
end

get '/oh_no' do
    raise "oh no what is happening"
end
