require 'spec_helper'

describe SubcriptionProduct do
  it "should allowed to create subcription product" do
    sp = SubcriptionProduct.create_object(
      :name         =>  "Super promo 2014 90 hari"   ,
      :vehicle_case => VEHICLE_CASE[:car]            ,
      :duration     => 90                            ,
      :description  => "Awesome promo"               ,
      :price        => 81 * BigDecimal("10000")
    )
    
    sp.should be_valid
  end
  
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
      
      @motor_vr_1 = @vehicle_1
      @car_vr_1 = @vehicle_2
    end
    
     
    
    
  end
  
  
end
