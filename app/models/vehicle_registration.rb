class VehicleRegistration < ActiveRecord::Base
   
  validates_presence_of :customer_id, :vehicle_id  
  
  belongs_to :customer_id
  belongs_to :vehicle_id 
  
  has_many :subcription_registrations
  has_many :subcription_products ,:through => :subcription_registrations 
  
  validate :valid_customer_id
  validate :valid_vehicle_id  
  validate :no_duplicated_vehicle_registration 
  
  
  has_many :tickets 
  
  def valid_customer_id
    return if not customer_id.present? 
    object = Customer.find_by_id customer_id
    if object.nil?
      self.errors.add(:customer_id, "Harus ada")
      return self 
    end
  end
  
  def valid_vehicle_id
    return if not vehicle_id.present? 
    object = Vehicle.find_by_id customer_id
    if object.nil?
      self.errors.add(:vehicle_id, "Harus ada")
      return self 
    end
  end
  
  def no_duplicated_vehicle_registration
    return if not vehicle_id.present? 
    return if not customer_id.present? 
    
    ordered_detail_count  = VehicleRegistration.where(
      :customer_id => customer_id,
      :vehicle_id => vehicle_id,
      :is_deactivated => false 
    ).count 
    
    ordered_detail = VehicleRegistration.where(
      :customer_id => customer_id,
      :vehicle_id => vehicle_id,
      :is_deactivated => false 
    ).first
    
    if self.persisted? and ordered_detail.id != self.id   and ordered_detail_count == 1
      self.errors.add(:vehicle_id, "Kendaraan harus uniq dalam 1 customer")
      return self 
    end
    
    # there is item with such item_id in the database
    if not self.persisted? and ordered_detail_count != 0 
      self.errors.add(:vehicle_id, "Kendaraan harus uniq dalam 1 customer")
      return self
    end
  end
  
  
 
  
  def self.create_object( params ) 
    new_object           = self.new
  
    new_object.customer_id    = params[:customer_id]
    new_object.vehicle_id  = params[:vehicle_id] 
    new_object.save
    
    return new_object
  end
  
  
   
  
  def update_object(params)
  
    if self.tickets.count != 0
      self.errors.add(:generic_error, "Sudah ada tiket parkir")
      return self 
    end
  
    self.customer_id    = params[:customer_id]
    self.vehicle_id  = params[:vehicle_id]
    
    self.save
    
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
    self.where(:is_deactivated => false )
  end
end
