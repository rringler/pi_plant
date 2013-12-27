desc "Take a sample for each plant"
task :sample => :environment do
  Plant.all.each do |plant|
    #TODO: take a sample for each plant
  end
end
