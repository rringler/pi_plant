desc "Take a sample for each plant"
task :sample => :environment do
  Plant.all.each { |plant| plant.check_moisture_and_water_if_necessary }
end
