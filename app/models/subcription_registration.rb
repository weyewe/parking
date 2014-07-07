class SubcriptionRegistration < ActiveRecord::Base
   
  validates_presence_of :subcription_product_id, :vehicle_registration_id  ,  :registration_date , :start_subcription_date
  belongs_to :vehicle_registration
  belongs_to :subcription_product
  has_many :tickets 
  
  
   
  
  
  validate :valid_vehicle_registration_id
  validate :valid_subcription_product_id  
  
  validate :vehicle_registration_has_equal_vehicle_case_to_subcription_product
  validate :vehicle_registration_does_not_have_overlapping_subcription
  
  
  
  
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
  
  
  def vehicle_registration_has_equal_vehicle_case_to_subcription_product
    return if not vehicle_registration_id.present? 
    return if not subcription_product_id.present? 
    
    if vehicle_registration.vehicle.vehicle_case != subcription_product.vehicle_case 
      self.errors.add(:generic_errors, "Tipe kendaraan harus sesuai dengan tipe product: harus sama-sama mobil atau motor")
      return self
    end
  end
  
  def vehicle_registration_does_not_have_overlapping_subcription
    return if not vehicle_registration_id.present? 
    return if not subcription_product_id.present?
    
    
    current_start_subcription = self.start_subcription_date 
    current_finish_subcription = self.start_subcription_date + subcription_product.duration.days 
    current_vehicle_registration_id = vehicle_registration_id 
    
    ordered_detail_count = SubcriptionRegistration.where{
      (vehicle_registration_id.eq current_vehicle_registration_id ) & 
      (
        (
          ( start_subcription_date.lte current_start_subcription) & 
          ( finish_subcription_date.gte current_start_subcription) & 
          ( finish_subcription_date.lte current_finish_subcription )
        ) | 
        (
          ( start_subcription_date.gte current_start_subcription) & 
          ( start_subcription_date.lte current_finish_subcription) & 
          ( finish_subcription_date.lte current_finish_subcription )
        ) |
        (
          ( start_subcription_date.gte current_start_subcription) &
          ( start_subcription_date.lte current_finish_subcription) &  
          ( finish_subcription_date.gte current_finish_subcription )
        ) 
      )
    }.count
    
    return if ordered_detail_count == 0 
    
    ordered_detail = self.class.where{
      (vehicle_registration_id.eq current_vehicle_registration_id ) & 
      (
        (
          ( start_subcription_date.lte current_start_subcription) & 
          ( finish_subcription_date.gte current_start_subcription) & 
          ( finish_subcription_date.lte current_finish_subcription )
        ) | 
        (
          ( start_subcription_date.gte current_start_subcription) & 
          ( start_subcription_date.lte current_finish_subcription) & 
          ( finish_subcription_date.lte current_finish_subcription )
        ) |
        (
          ( start_subcription_date.gte current_start_subcription) &
          ( start_subcription_date.lte current_finish_subcription) &  
          ( finish_subcription_date.gte current_finish_subcription )
        ) 
      )
    }.first
    
    if self.persisted? and ordered_detail.id != self.id   and ordered_detail_count == 1
      self.errors.add(:generic_errors, "Ada overlapping tanggal subcription")
      return self 
    end
    
    # there is item with such item_id in the database
    if not self.persisted? and ordered_detail_count != 0 
      self.errors.add(:generic_errors, "Ada overlapping tanggal subcription")
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
