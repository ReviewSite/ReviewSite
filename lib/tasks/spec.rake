namespace :spec do

  if defined?(RSpec)
    desc 'Run all examples but integration'
    RSpec::Core::RakeTask.new(unit: 'db:test:prepare') do |t|
      t.pattern = 'spec/{controllers,helpers,mailers,models,routing}/**/*_spec.rb'
    end
  end
  
  desc 'Run unit tests, requests and javascript'
  task :ci => ['spec', 'spec:requests', 'spec:javascript']
end
