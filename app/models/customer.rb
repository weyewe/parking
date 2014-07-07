class Customer < ActiveRecord::Base
  attr_accessible :name, :address, :email  
   
  validates_presence_of :name  , :id_card_number
  validates_uniqueness_of :id_card_number 
  
  has_many :vehicles, :through => :vehicle_registrations
  has_many :vehicle_registrations 
 
  
  def self.create_object( params ) 
    new_object           = self.new
    new_object.name    =  ( params[:name].present? ? params[:name   ].to_s.upcase : nil )  
    new_object.id_card_number    =  ( params[:id_card_number].present? ? params[:id_card_number   ].to_s.upcase.to_s.upcase.gsub(/\s+/, "") : nil )  
    new_object.address  = params[:address]
    new_object.contact  = params[:contact]
    new_object.email    = params[:email  ] 
    new_object.save
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    self.name    =  ( params[:name].present? ? params[:name   ].to_s.upcase : nil  ) 
    self.id_card_number    =  ( params[:id_card_number].present? ? params[:id_card_number   ].to_s.upcase.to_s.upcase.gsub(/\s+/, "") : nil ) 
    self.address  = params[:address]
    self.contact  = params[:contact]
    self.email    = params[:email  ] 
    self.save
    
    return self
  end
  
  def delete_object
    
    self.is_deleted  = true 
    self.save  
    
  end 
  
  
  def self.active_objects
    self.where(:is_deleted => false )
  end
end
