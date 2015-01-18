def run_spec(file)
  unless File.exist?(file)
    puts "#{file} does not exist"
    return
  end

  puts "Running #{file}"

  if File.extname(file) == ".js" 
    system "bundle exec rake spec:javascript SPEC=#{file}"
  else
    system "rspec #{file}"  
  end  

  puts

end

watch("^spec/.*/*_spec.rb") do |match|
  run_spec match[0]
end

watch("^app/(.*).rb") do |match|
  run_spec %{spec/#{match[1]}_spec.rb}
end

watch("^app/(.*).erb") do |match|
  run_spec %{spec/#{match[1]}.erb_spec.rb}
end

watch("^lib/(.*).rb") do |match|
  run_spec %{spec/lib/#{match[1]}_spec.rb}
end

watch("^app/assets/javascripts/(.*).js") do |match|
  run_spec %{spec/javascripts/#{match[1]}_spec.js}
end

watch("^app/assets/javascripts/(.*).coffee") do |match|
  run_spec %{spec/javascripts/#{match[1]}_spec.js}
end

watch("^spec/javascripts/(.*)_spec.js") do |match|
  run_spec match[0]
end
