require 'spec_helper'

describe Customer do
  it "should parse id number" do
    customer = Customer.create_object(
      :name           => "Name awesome",
      :id_card_number => "1123 324 42 ",
      :address        => "Address"     ,
      :contact        => ""    ,
      :email          =>  ""   ,
    )
    
    customer.errors.size.should == 0 
    customer.should be_valid
  end
  
  it "should not allow customer with no id number" do
    customer = Customer.create_object(
      :name           => "Name awesome",
      :id_card_number => " ",
      :address        => "Address"     ,
      :contact        =>""      ,
      :email          =>  ""      ,
    )
    
    customer.should_not be_valid 
  end
end
