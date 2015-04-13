
begin
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :test_with_coveralls => [:spec, 'coveralls:push']
rescue LoadError
  
end
