role = {
  :system => {
    :administrator => true
  }
}

admin_role = Role.create!(
  :name        => ROLE_NAME[:admin],
  :title       => 'Administrator',
  :description => 'Role for administrator',
  :the_role    => role.to_json
)

role = {
  :passwords => {
    :update => true 
  },
  :works => {
    :index => true, 
    :create => true,
    :update => true,
    :destroy => true,
    :work_reports => true ,
    :project_reports => true ,
    :category_reports => true 
  },
  :projects => {
    :search => true 
  },
  :categories => {
    :search => true 
  }
}

data_entry_role = Role.create!(
  :name        => ROLE_NAME[:data_entry],
  :title       => 'Data Entry',
  :description => 'Role for data_entry',
  :the_role    => role.to_json
)



# if Rails.env.development?

  admin = User.create_main_user(  :name => "Admin", :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user


  admin = User.create_main_user(  :name => "Admin2", :email => "admin2@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user
  
  admin = User.create_main_user(  :name => "Admin4", :email => "admin4@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user


  
  customer_1 = Customer.create_object(
    :name        => "mcnell", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "walawee@gmail.com", 
  )
  
  customer_2 = Customer.create_object(
    :name        => "toll", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "toll@gmail.com", 
  )
  
  customer_3 = Customer.create_object(
    :name        => "penanshin", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "toll@gmail.com", 
  )
  
  customer_array = [customer_1, customer_2, customer_3 ]
  
  puts "Total customer : #{Customer.count}"
  

  (1..3).each do |x|
    vehicle_case = VEHICLE_CASE[:car]
    license_plate = "b  #{x} #{vehicle_case}"
    Vehicle.create_object(
      :license_plate_no => license_plate , 
      :vehicle_case     => vehicle_case,
      :description      =>  "Description #{vehicle_case}"
    )
    
    vehicle_case = VEHICLE_CASE[:motor]
    license_plate = "b  #{x} #{vehicle_case}"
    Vehicle.create_object(
      :license_plate_no => license_plate , 
      :vehicle_case     => vehicle_case,
      :description      =>  "Description #{vehicle_case}"
    )

    
  end


  puts "Total vehicle: #{Vehicle.count}"
  
  (1..3).each do |x|
    
    vehicle_case = VEHICLE_CASE[:car]
    duration = vehicle_case* x * 30 
    price = duration * BigDecimal("1000") * vehicle_case 
    
    SubcriptionProduct.create_object(
      :name         => "Name #{x}, #{duration}"             ,
      :vehicle_case => vehicle_case                         ,
      :duration     => duration                             ,
      :description  => "description #{x}, #{vehicle_case}"  ,
      :price        => price

    )
    
    
    vehicle_case = VEHICLE_CASE[:motor]
    duration = vehicle_case* x * 30 
    price = duration * BigDecimal("1000") * vehicle_case 
    
    SubcriptionProduct.create_object(
      :name         => "Name #{x}, #{duration}"             ,
      :vehicle_case => vehicle_case                         ,
      :duration     => duration                             ,
      :description  => "description #{x}, #{vehicle_case}"  ,
      :price        => price

    )
    
    
  end
  
  puts "Total subcription product: #{SubcriptionProduct.count}"
  
  counter = 0 
  Vehicle.all.each do |vehicle|
    
    index = counter % customer_array.length 
    
    VehicleRegistration.create_object(
      :customer_id    => customer_array[index].id, 
      :vehicle_id     => vehicle.id 
    )
    counter += 1 
  end
  
  puts "Total vehicle registration: #{VehicleRegistration.count}"
  
  
  
  
  vehicle_case =  VEHICLE_CASE[:motor]
  price  = BigDecimal("2000")
  PriceRule.create_object(
    :is_base_price => true           ,
    :vehicle_case  => vehicle_case    ,
    :hour          =>  nil             ,
    :price         =>  price
  )
  
  
  vehicle_case =  VEHICLE_CASE[:car]
  price  = BigDecimal("4000")
  PriceRule.create_object(
    :is_base_price => true           ,
    :vehicle_case  => vehicle_case    ,
    :hour          => nil              ,
    :price         =>    price
  )
  
  

  (1..3).each do |x|
    vehicle_case =  VEHICLE_CASE[:motor]
    price  = BigDecimal("2000")
    a =  PriceRule.create_object(
    :is_base_price => false           ,
    :vehicle_case  => vehicle_case    ,
    :hour          => x               ,
    :price         =>  x * price
    )

    a.errors.messages.each {|x| puts "The error: #{x}"}


    vehicle_case =  VEHICLE_CASE[:car]
    price  = BigDecimal("4000")
    PriceRule.create_object(
    :is_base_price => false           ,
    :vehicle_case  => vehicle_case    ,
    :hour          => x               ,
    :price         =>  x * price
    )

  end

  puts "Total price rule: #{PriceRule.count}"
   
  