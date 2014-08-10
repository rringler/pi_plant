desc "Take a sample for each plant"
task :sample => :environment do
  Plant.all.each { |plant| plant.check_moisture_and_water_if_necessary }
end

desc "Test all pumps by turning them on for 5 seconds"
task :test_pumps => :environment do
  Plant.all.each do |plant|
    plant.send(:pump).send(:on)
    sleep(5)
    plant.send(:pump).send(:off)
  end
end