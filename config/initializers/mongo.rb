MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
MongoMapper.database = "#controle-ponto-eletronico-#{Rails.env}"

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    MongoMapper.connection.connect if forked
  end
end