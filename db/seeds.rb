require 'faker'
require 'creek'

puts 'Cleaning database...'
Role.destroy_all
puts 'Role.destroy_all done'

Salon.destroy_all
puts 'Salon.destroy_all done'

User.destroy_all
puts 'User.destroy_all done'

#Admin.destroy_all

Service.destroy_all
puts 'Service.destroy_all done '
Photo.destroy_all
puts 'Photo.destroy_all done '
Appointment.destroy_all
puts 'Appointment.destroy_all done '
WorkingHour.destroy_all
puts 'WorkingHour.destroy_all done '
OpeningHour.destroy_all
puts 'OpeningHour.destroy_all done '


xlsData = Creek::Book.new './db/info_institut.xlsx'
puts "✅ success Reading Excel file "

users = xlsData.sheets[0]
salons = xlsData.sheets[1]
openingHours = xlsData.sheets[2]
services = xlsData.sheets[3]
roles = xlsData.sheets[4]
photos = xlsData.sheets[5]

puts "✅ success Reading sheets "


  # user sheet (title order) => user_id / email	/ first_name /	last_name /	phone_number /	city /	address	title.
  users.rows.each_with_index do |user, index|
    # skipping first rows only containing titles no data
    next if index+1 < 2
    if !user.nil? && !user["A#{index+1}"].to_s.empty?
    User.create(
      id: user["A#{index+1}"],
      email: user["B#{index+1}"],
      password: "@quamoon",
      first_name: user["C#{index+1}"],
      last_name: user["D#{index+1}"],
      phone_number: user["E#{index+1}"],
      city: user["F#{index+1}"],
      address: user["G#{index+1}"]
    )
  end
end

  puts "✅ success Creating users from spread sheet "

  # salon sheet (title order) => salon_id /	name /	city /	address /	phone

  salons.rows.each_with_index do |salon, index|

    # skipping first rows only containing titles no data
    next if index+1 < 2

    if !salon.nil? && !salon["A#{index+1}"].to_s.empty?
    p "creating salon : #{salon["B#{index+1}"]}"
    s = Salon.create(
      id: salon["A#{index+1}"],
      name: salon["B#{index+1}"],
      description: salon["B#{index+1}"],
      city: salon["C#{index+1}"],
      address: salon["D#{index+1}"],
      phone_number: salon["E#{index+1}"],
      latitude: salon["F#{index+1}"],
      longitude: salon["G#{index+1}"]
    )
    p s.to_json
    end
  end
  puts "✅ success Creating Salons from spread sheet "

  # opening_hour sheet (title order) =>  opening_hour_id /	salon_id /	day	/ start_hour /	end_hour
  openingHours.rows.each_with_index do |openingHour, index|
    # skipping first rows only containing titles no data
    next if index+1 < 2

    o = OpeningHour.create(
      id: openingHour["A#{index+1}"],
      salon_id: openingHour["B#{index+1}"],
      day: openingHour["C#{index+1}"],
      start_hour: openingHour["D#{index+1}"],
      end_hour: openingHour["E#{index+1}"]
    )
  end

  puts "✅ success Creating OpeningHours from spread sheet "

   # Services sheet (title order) =>  service_id	/ salon_id /	name /	description /	duration_min /	category /	price_cents
   services.rows.each_with_index do |service, index|
    # skipping first rows only containing titles no data
    next if index+1 < 2
    if !service.nil? && !service["A#{index+1}"].to_s.empty?
    se = Service.new(
      id: service["A#{index+1}"],
      salon_id: service["B#{index+1}"],
      name: service["C#{index+1}"],
      description: service["D#{index+1}"],
      duration: service["E#{index+1}"],
      category: service["F#{index+1}"],
      price_cents: service["G#{index+1}"]
    )

    puts se.validate!
    puts se.save()
    end
  end

  puts "✅ success Creating Services from spread sheet "

   #Roles sheet (title order) =>   role_id	user_id	salon_id	role
   roles.rows.each_with_index do |role, index|
    # skipping first rows only containing titles no data
    next if index+1 < 2

    Role.create(
      id: role["A#{index+1}"],
      user_id: role["B#{index+1}"],
      salon_id: role["C#{index+1}"],
      role: role["D#{index+1}"]
    )

  end
  puts "✅ success Creating roles from spread sheet "

   #Photos sheet (title order) =>   id	salon_id	photo_url
   photos.rows.each_with_index do |photo, index|
    # skipping first rows only containing titles no data
    next if index+1 < 2

    Photo.create(
      id: photo["A#{index+1}"],
      salon_id: photo["B#{index+1}"],
      photo_url: photo["C#{index+1}"]
    )
  end

puts "✅ success Creating photos from spread sheet "

 Salon.all.each do |salon|
  if(salon.photos.count == 0 )
    photo = Photo.create(photo_url: "paint.jpg", salon: salon)
    puts "⚠️ Salon id => #{salon.id} has nos attached picture a default picture has been set"
  end
end
puts "✅ success setting default pictures for picture-less salons..."









