require 'spec_helper'

describe SubcriptionRegistration do
  context "creating subcription" do
    before(:each) do
      
      @customer_1 = Customer.create_object(
        :name           => "Name awesome",
        :id_card_number => "1123 324 42 ",
        :address        => "Address"     ,
        :contact        => ""    ,
        :email          =>  ""   ,
      )

      @customer_2 = Customer.create_object(
        :name           => "Name 2 awesome",
        :id_card_number => "1123 324 aa 42 ",
        :address        => "Address"     ,
        :contact        => ""    ,
        :email          =>  ""   ,
      )

      @vehicle_1 = Vehicle.create_object(
        :license_plate_no => "B 111 A", 
        :vehicle_case     => VEHICLE_CASE[:motor], 
        :description      => "Awesome"
      )


      @vehicle_2 = Vehicle.create_object(
        :license_plate_no => "B 111 B", 
        :vehicle_case     => VEHICLE_CASE[:car], 
        :description      => "Awesome"
      )
      
      @motor_vr_1 =   VehicleRegistration.create_object(
        :vehicle_id => @vehicle_1.id,
        :customer_id => @customer_1.id 
      )
      
      
      @car_vr_1 =  VehicleRegistration.create_object(
        :vehicle_id => @vehicle_2.id,
        :customer_id => @customer_2.id 
      )
      
      @sp_car_1 = SubcriptionProduct.create_object(
        :name         =>  "Super promo 2014 90 hari"   ,
        :vehicle_case => VEHICLE_CASE[:car]            ,
        :duration     => 90                            ,
        :description  => "Awesome promo"               ,
        :price        => 81 * BigDecimal("10000")
      )
    end
    
    it "should craeate all base variable"
    
    it "should allow subcription registration for the vehicle car" do
      @current_date = DateTime.now 
      @sr = SubcriptionRegistration.create_object(
      
        :vehicle_registration_id =>  @car_vr_1.id ,
        :subcription_product_id  => @sp_car_1.id,
        :registration_date       => @current_date     ,
        :start_subcription_date  => @current_date + 5.days,
      )
      
      @sr.should be_valid
    end
    
    it "should allow subcription registration for different vehicle car" do
      @current_date = DateTime.now 
      @sr = SubcriptionRegistration.create_object(
      
        :vehicle_registration_id =>  @motor_vr_1.id ,
        :subcription_product_id  => @sp_car_1.id,
        :registration_date       => @current_date     ,
        :start_subcription_date  => @current_date + 5.days,
      )
      
      @sr.errors.size.should_not == 0 
      @sr.should_not be_valid
    end
    
     
    
    
  end
  
  
end
