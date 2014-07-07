require 'spec_helper'

describe Vehicle do
  it "should parse id number" do
    
    
    license_plate = "B 2342 A"
    vehicle = Vehicle.create_object(
      :license_plate_no => license_plate, 
      :vehicle_case     => VEHICLE_CASE[:motor], 
      :description      => "Awesome" 
    
    )
    
    vehicle.errors.size.should == 0 
    vehicle.should be_valid
  end
  
  it "should not allow vehicle with no id number" do
    vehicle = Vehicle.create_object(
      :license_plate_no => "", 
      :vehicle_case     => VEHICLE_CASE[:motor], 
      :description      => "Awesome"
    )
    
    vehicle.should_not be_valid 
  end
  
  
  it "should not allow vehicle with no vehicle case" do
    vehicle = Vehicle.create_object(
      :license_plate_no => "a23e2", 
      :vehicle_case     => 4, 
      :description      => "Awesome"
    )
    
    vehicle.should_not be_valid 
  end
  
  context " there should not be double vehicle" do
    before(:each) do
      @license_plate_1 = "B 234 KK"
      @license_plate_2 = "B2 3 4 K K "
      @vehicle_1 = Vehicle.create_object(
        :license_plate_no => @license_plate_1, 
        :vehicle_case     => VEHICLE_CASE[:motor], 
        :description      => "Awesome"
      )
    end
    
    it "should create vehicle_1" do
      @vehicle_1.errors.size.should == 0 
      @vehicle_1.should be_valid
    end
    
    it "should not create another vehicle with the same plate number" do
      @vehicle_2 = Vehicle.create_object(
        :license_plate_no => @license_plate_2, 
        :vehicle_case     => VEHICLE_CASE[:motor], 
        :description      => "Awesome"
      )
      
      @vehicle_2.errors.size.should_not == 0 
      @vehicle_2.should_not be_valid 
    end
    
    it "should not create another vehicle with the same plate number even though the vehicle case is different" do
      @vehicle_2 = Vehicle.create_object(
        :license_plate_no => @license_plate_2, 
        :vehicle_case     => VEHICLE_CASE[:car], 
        :description      => "Awesome"
      )
      
      @vehicle_2.errors.size.should_not == 0 
      @vehicle_2.should_not be_valid
    end
  end
end
