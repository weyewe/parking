require 'spec_helper'

describe Ticket do
  it "should parse id number" do
    
    
    license_plate = "B 2342 A"
    ticket = Ticket.create_object(
      :license_plate_no => license_plate, 
      :vehicle_case     => VEHICLE_CASE[:motor], 
      :entry_datetime   =>DateTime.new(2014,2,2,10,0,0)
    )
    
    ticket.errors.size.should == 0 
    ticket.should be_valid
  end
  
  it "should not allow ticket with no license plate number" do
    ticket = Ticket.create_object(
      :license_plate_no => "", 
      :vehicle_case     => VEHICLE_CASE[:motor], 
      :entry_datetime   =>DateTime.new(2014,2,2,10,0,0)
    )
    
    ticket.errors.size.should_not == 0 
    ticket.should_not be_valid
  end
  
  
  it "should not allow ticket with no vehicle case" do
    ticket = Ticket.create_object(
      :license_plate_no => "B1231B", 
      :vehicle_case     =>  8 ,
      :entry_datetime   =>DateTime.new(2014,2,2,10,0,0)
    )
    
    ticket.errors.size.should_not == 0 
    ticket.should_not be_valid
  end
  
  context " there should not be double vehicle" do
    before(:each) do
      @license_plate_1 = "B 234 KK"
      @license_plate_2 = "B2 3 4 K K "
      @ticket_1 = Ticket.create_object(
        :license_plate_no => @license_plate_1, 
        :vehicle_case     => VEHICLE_CASE[:motor], 
        :entry_datetime   =>DateTime.new(2014,2,2,10,0,0)
      )
    end
    
    it "should create vehicle_1" do
      @ticket_1.errors.size.should == 0 
      @ticket_1.should be_valid
    end
    
    it "should not create another ticket with the same plate number" do
      @vehicle_2 = Ticket.create_object(
        :license_plate_no => @license_plate_1, 
        :vehicle_case     => VEHICLE_CASE[:motor], 
        :entry_datetime   =>DateTime.new(2014,2,2,10,0,0)
      )
      
      @vehicle_2.errors.size.should_not == 0 
      @vehicle_2.should_not be_valid 
    end
    
    it "should not create another vehicle with the same plate number even though the vehicle case is different" do
      @vehicle_2 = Ticket.create_object(
        :license_plate_no => @license_plate_1, 
        :vehicle_case     => VEHICLE_CASE[:car], 
        :entry_datetime   =>DateTime.new(2014,2,2,10,0,0)
      )
      
      @vehicle_2.errors.size.should_not == 0 
      @vehicle_2.should_not be_valid
    end
  end
end
