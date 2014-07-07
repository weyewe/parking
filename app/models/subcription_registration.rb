class SubcriptionRegistration < ActiveRecord::Base
   
  validates_presence_of :subcription_product_id, :vehicle_registration_id  ,  :registration_date , :start_subcription_date
  belongs_to :vehicle_registration
  belongs_to :subcription_product
  has_many :tickets 
  
  
   
  
  
  validate :valid_vehicle_registration_id
  validate :valid_subcription_product_id  
  
  
  
  
  def valid_vehicle_registration_id
    return if not vehicle_registration_id.present? 
    object = VehicleRegistration.find_by_id vehicle_registration_id 
    
    if object.nil?
      self.errors.add(:vehicle_registration_id, "Harus ada")
      return self 
    end
  end
  
  def valid_subcription_product_id 
    return if not subcription_product_id .present? 
    object = SubcriptionProduct.find_by_id subcription_product_id 
    if object.nil?
      self.errors.add(:subcription_product_id , "Harus ada")
      return self 
    end
  end
  
  
 
  
  def self.create_object( params ) 
    new_object           = self.new
  
    new_object.vehicle_registration_id    = params[:vehicle_registration_id]
    new_object.subcription_product_id   = params[:subcription_product_id ] 
    new_object.registration_date = params[:registration_date]
    new_object.start_subcription_date = params[:start_subcription_date]
    
    if new_object.save
      new_object.finish_subcription_date = new_object.start_subcription_date + new_object.subcription_product.duration.days 
      new_object.save 
    end
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    if self.tickets.count != 0
      self.errors.add(:generic_error, "Sudah ada tiket parkir")
      return self 
    end
    
    self.vehicle_registration_id    = params[:vehicle_registration_id]
    self.subcription_product_id   = params[:subcription_product_id ] 
    self.registration_date = params[:registration_date]
    self.start_subcription_date = params[:start_subcription_date]
   
    if self.save
      self.finish_subcription_date = self.start_subcription_date + self.subcription_product.duration.days 
      self.save
    end
    
    return self
  end
  
  
  
  def delete_object
    if self.tickets.count !=  0
      self.errors.add(:generic_errors, "Sudah ada pendaftaran ticket")
      return self
    end
     
    
    self.destroy
  end 
  
  
  def self.active_objects
    self 
  end
end
