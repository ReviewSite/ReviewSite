namespace :spec do
    RSpec::Core::RakeTask.new(:fast) do |t|
        t.pattern = Dir['spec/*/**/*_spec.rb'].reject{ |f| f['/requests'] }
    end
end	
