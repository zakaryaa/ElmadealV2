require 'faker'
require 'geocoder'
require 'cloudinary'
require 'creek'

addRealData = true

puts 'Cleaning database...'
# Role.destroy_all
# Salon.destroy_all
# User.destroy_all # Should only destroy owners & employee
# Admin.destroy_all # Should only destroy owners & employee
# Service.destroy_all
# Photo.destroy_all
# Appointment.destroy_all
# WorkingHour.destroy_all
# OpeningHour.destroy_all

if addRealData
  puts "Adding real data..."

#  Admin.create(
 #   email: "admin@elmadeal.com", 
 #   password: "123456", 
 # )

 # puts "✅ Admin User created"


  xlsData = Creek::Book.new './db/info_institut-Aquamoon.xlsx'
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
    next if user["A#{index+1}"].nil?
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
  
  puts "✅ success Creating users from spread sheet "

  # salon sheet (title order) => salon_id /	name /	city /	address /	phone 

  salons.rows.each_with_index do |salon, index|
    
    # skipping first rows only containing titles no data
    next if index+1 < 2

    Salon.create(
      id: salon["A#{index+1}"],
      name: salon["B#{index+1}"], 
      description: salon["B#{index+1}"], 
      city: salon["C#{index+1}"], 
      address: salon["D#{index+1}"], 
      phone_number: salon["E#{index+1}"],
      latitude: salon["F#{index+1}"],
      longitude: salon["G#{index+1}"]
    )
  end
  puts "✅ success Creating Salons from spread sheet "

  # opening_hour sheet (title order) =>  opening_hour_id /	salon_id /	day	/ start_hour /	end_hour
  openingHours.rows.each_with_index do |openingHour, index|
    # skipping first rows only containing titles no data
    next if index+1 < 2

    OpeningHour.create(
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
    
    Service.create(
      id: service["A#{index+1}"],
      salon_id: service["B#{index+1}"],
      name: service["C#{index+1}"],
      description: service["D#{index+1}"], 
      duration: service["E#{index+1}"],
      category: service["F#{index+1}"], 
      price_cents: service["G#{index+1}"]
    )
    
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
  
  # custom task to fix PostgreSQL id Sequences due to hard id creation
  Rake::Task['db:sequence_reset'].invoke

else
  puts "Adding fake data..."

  puts 'Creating users...'
  user = User.create(email: Faker::Internet.email, password: '123456', first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, phone_number: Faker::PhoneNumber.cell_phone, city: Faker::Address.city, birthday: Faker::Date.birthday(18, 65), position: ["owner", "employee", "customer"].sample)
  admin = Admin.create(email: 'admin@elmadeal.com' , password: '123456')

  owner = User.create(email: "owner@elma.com", password: '123456', first_name: "owner", last_name: "last_name", phone_number: "000000", city: "dakar", birthday: Faker::Date.birthday(18, 65), position: "owner")
  customer = User.create(email: "customer@elma.com", password: '123456', first_name: "customer", last_name: "last_name", phone_number: "000000", city: "dakar", birthday: Faker::Date.birthday(18, 65), position: "customer")
  employee = User.create(email: "employee@elma.com", password: '123456', first_name: "employee", last_name: "last_name", phone_number: "000000", city: "dakar", birthday: Faker::Date.birthday(18, 65), position: "employee")

  2.times do
    # Create users
    puts "👯 User #{user.email} created"
    2.times do
      # Create salons
      salon_descriptions = ["Established beauty therapists.", "Leading well-being center.", "Specialised in beauty treatments.", "Indulgent treatments for all.", "20 years of experience.", "Modern hub for creative styling.", "Unisex salon.", "Unique, modern salon.", "Treatments you can afford.", "Complete hair and beauty experience.", "Glamourous unisex boutique style salon.", "Experts in beauty.", "Chilled out hairdresser.", "Specialised in everyday beauty.", "A relaxing escape.", "Brand new beauty salon.", "Specialised in hair and beauty.", "Professionals at your service.", "Chic and stylish salon.", "Ultimate relaxation."]
      salon_addresses = ['Boulevard Ghandi, Casablanca', 'Avenue Hassan II, Casablanca', 'Rue Socrate, Casablanca', 'Boulevard Sidi Mohamed Ben Abdellah, Casablanca', 'Boulevard Raphael, Casablanca', 'Rue des Papillons, Casablanca', 'Avenue des Sports, Casablanca', 'Rue Al Wouroud, Casablanca', 'Avenue Lalla Yacout, Casablanca', 'Boulevard Moulay Idriss I, Casablanca', 'Rue el Imam Chafii, Marrakesh', 'Avenue Houmane El Fetouaki, Marrakesh', 'Avenue Imam El Ghazali, Marrakesh', 'Rue Bab Doukkala, Marrakesh', 'Rue el Gza, Marrakesh', 'Derb Sidi Bou Amar, Marrakesh', 'Rue Bin Lafnadek, Marrakesh', 'Derb El Hammam, Marrakesh', 'Rue el Ksour, Marrakesh', 'Avenue Antaki, Marrakesh', 'Route California, Tangier', 'Avenue Moulay Youssef, Tangier', 'Rue Mimousa, Tangier', 'Avenue Mohamed VI, Tangier', 'Avenue Raimundo Lulio, Tangier', 'Rue Zoubeir Ben Aouam, Tangier', 'Avenue Marrakech, Tangier', 'Rue Ibn Khatib, Tangier', 'Rue Nouvelle, Tangier', 'Avenue Pasteur, Tangier', 'Avenue Al Atlas, Rabat', 'Avenue Jean Jaurès, Rabat', 'Avenue Ibn Sina, Rabat', 'Avenue Ibn Sina, Rabat', 'Avenue Al Melia, Rabat', 'Rue Bani Ourraine, Rabat', 'Avenue 16 Novembre, Rabat', 'Rue Toudgha, Rabat', 'Rue Sahnoun, Rabat', 'Rue Znaidi, Rabat']
      salon = Salon.new(name: Faker::Company.name + ' ' + ['Salon', 'Beauty', 'Hairdresser', 'Beautician', 'Hair Salon', 'Beauty Salon', 'Beauty Hut', 'Beauty Experts', 'Salon & Academy', 'Hairdressing', 'Beauty Room', 'Beauty Hub'].sample, description: salon_descriptions.sample, address: salon_addresses.sample, phone_number: Faker::PhoneNumber.cell_phone)
      salon.city = salon.address.partition(',').last.gsub(" ", "")
      salon.user = user
      salon.save
      Salon.all.each do |current_salon|
        if salon.description == current_salon.description
          salon.description = salon_descriptions.sample
          salon.save
        end
        if salon.address = current_salon.address
          salon.address = salon_addresses.sample
          salon.save
          salon.city = salon.address.partition(',').last.gsub(" ", "")
          salon.save
        end
      end
      puts "✅ Salon #{salon.name} created in #{salon.city} for #{user.email}"

      2.times do |n|
        # Create opening hours
        opening_hour = OpeningHour.new(day: %w(monday tuesday wednesday thursday friday saturday sunday).sample, start_hour: Faker::Time.between(DateTime.now - 1, DateTime.now), end_hour: DateTime.now)
        opening_hour.salon = salon
        opening_hour.save
        puts "⏰ Opening hour #{n+1} created for #{salon.name}"

        # Create photos
        cloudinary_random_photo = Cloudinary::Api.resources(:type => :upload)["resources"].map { |cloudinary_photo| cloudinary_photo["url"] }.sample
        photo = Photo.new(photo_url: Cloudinary::Api.resources(:type => :upload)["resources"].map { |cloudinary_photo| cloudinary_photo["url"] }.sample)
        photo.salon = salon
        photo.save
        salon.photos.uniq
        salon.save
        puts "📸 Photo created for #{salon.name}"

        # Create services
        ['ladies haircut', 'mens haircut', 'colour', 'ombre', 'balyage', 'highlights', 'deep conditioning', 'hair wash', 'extensions', 'braids', 'weaves', 'beard trimming', 'wedding hair', 'hair styling', 'straightening'].each do |service|
          service = Service.new(name: service, description: Faker::Lorem.sentence(5),category: 'Hair', duration: [15, 30, 40, 45, 60, 90, 120].sample, price: [1, 2, 5, 7, 10, 12].sample)
          service.salon = salon
          service.save
          puts "💅 Service #{service.name} created for #{salon.name}"
        end
        ['standard pedicure', 'standard manicure', 'gel manicure', 'gel pedicure', 'polish removal', 'acrylic nails', 'nail art'].each do |service|
          service = Service.new(name: service, description: Faker::Lorem.sentence(5), category: 'Nails', duration: [15, 30, 40, 45, 60, 90, 120].sample, price: [1, 2, 5, 7, 10, 12].sample)
          service.salon = salon
          service.save
          puts "💅 Service #{service.name} created for #{salon.name}"
        end
        ['back massage', 'leg massage', 'sports massage', 'thai massage', 'swedish massage', 'hotstone massage', 'chinese massage', 'oil massage', 'therapeutic massage'].each do |service|
          service = Service.new(name: service, description: Faker::Lorem.sentence(5), category: 'Massage', duration: [15, 30, 40, 45, 60, 90, 120].sample, price: [1, 2, 5, 7, 10, 12].sample)
          service.salon = salon
          service.save
          puts "💅 Service #{service.name} created for #{salon.name}"          \
        end
        ['standard facial', 'eyelash extensions', 'eyelash tint', 'eyebrow threading', 'makeup', 'eyebrow tint'].each do |service|
          service = Service.new(name: service, description: Faker::Lorem.sentence(5), category: 'Face', duration: [15, 30, 45, 60, 90, 120].sample, price: [1, 2, 5, 7, 10, 12].sample)
          service.salon = salon
          service.save
          puts "💅 Service #{service.name} created for #{salon.name}"
        end
        salon.services.sample(25).each do |service|
          service.destroy
        end
        puts "❌ Removed services from #{salon.name}"


        2.times do |t|
          # Create appointments
          appointment = Appointment.new(start_appointment: Faker::Time.between(DateTime.now - 1, DateTime.now), end_appointment: DateTime.now)
          appointment.user = user
          appointment.service = Service.all.sample
          appointment.save
          puts "📅 Appointment #{t+1} created for #{user.email} at #{salon.name}"

          # Create working hours
          working_hour = WorkingHour.new(start_shift: Faker::Time.between(DateTime.now - 1, DateTime.now), end_shift: DateTime.now)
          working_hour.user = user
          working_hour.service = Service.all.sample
          working_hour.save
          puts "⏳ Working hour #{t+1} created for #{user.email}"
        end
      end
    end
  end
  puts 'Done!'
end
