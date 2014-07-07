require 'spec_helper'

describe Vehicle do
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
      :vehicle_case     => VEHICLE_CASE[:motor], 
      :description      => "Awesome"
    )
  end
  
  it "should create valid customer and vehicle" do
    @customer_1.should be_valid
    @customer_2.should be_valid
    @vehicle_1.should be_valid 
  end
  
  it "should allow vehicle registration" do
    @vr = VehicleRegistration.create_object(
      :vehicle_id => @vehicle_1.id,
      :customer_id => @customer_1.id 
    )
    
    @vr.should be_valid 
    @vr.errors.size.should == 0 
  end
  
  context "post vehicle registration" do
    before(:each) do
      @vr = VehicleRegistration.create_object(
        :vehicle_id => @vehicle_1.id,
        :customer_id => @customer_1.id 
      )
    end
    
    it "should not  double vehicle registartion" do
      @vr_2 = VehicleRegistration.create_object(
        :vehicle_id => @vehicle_1.id,
        :customer_id => @customer_1.id 
      )
      
      @vr_2.errors.size.should_not == 0
    end
    
    it "should not  double vehicle registartion" do
      @vr_2 = VehicleRegistration.create_object(
        :vehicle_id => @vehicle_1.id,
        :customer_id => @customer_2.id 
      )
      
      @vr_2.errors.size.should_not == 0
    end
    
    it "should allow one customer to have 2 vehicle registration" do
      @vr_2 = VehicleRegistration.create_object(
        :vehicle_id => @vehicle_2.id,
        :customer_id => @customer_1.id 
      )
      
      @vr_2.errors.size.should == 0
      @vr_2.should be_valid 
    end
    
    context "deactivate vehicle registration 1 " do
      before(:each) do
        @vr.deactivate_object(
          :deactivation_date => DateTime.now ,
          :deactivation_description => "Awesome deactivation"
        )
      end
      
      it "should deactivate" do
        @vr.is_deactivated.should be_true 
      end
      
      it "should be allowed to create another registration" do
        @vr = VehicleRegistration.create_object(
          :vehicle_id => @vehicle_1.id,
          :customer_id => @customer_1.id 
        )
        
        @vr.errors.size.should == 0 
        @vr.should be_valid
      end
    end
  end
end
