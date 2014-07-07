class Ticket < ActiveRecord::Base
   
  validates_presence_of :license_plate_no, :vehicle_case , :entry_datetime   
  
  validate :valid_vehicle_case 
   
  def valid_vehicle_case
    return if not vehicle_case.present? 
    if not [
              VEHICLE_CASE[:car],
              VEHICLE_CASE[:motor]].include?( vehicle_case  ) 
              
      self.errors.add(:vehicle_case , "Harus ada jenis kendaraan")
      return self
    end
  end
  
  
 
  
  
  def generate_booking_code
    unique = false 
    proposed_booking_code = ''
    
    while not unique  do
      proposed_booking_code =  UUIDTools::UUID.timestamp_create.to_s[0..4]

      counter = Ticket.where{
        (code.eq proposed_booking_code) & 
        (is_exit.eq false ) & 
        (is_deleted.eq false) 
      }.count
      
      unique = true if counter == 0 
    end
    
    self.code = proposed_booking_code
    self.save 
  end
  
  def assign_subcription_registration
    # 1. check if there is vehicle registered with that plate number 
    object = Vehicle.find_by_license_plate_no( license_plate_no ) 
    
    return if object.nil?
    
    # check if there is any active subcription today 
    vehicle_registration = VehicleRegistration.find_by_vehicle_id object.id 
    return if vehicle_registration.nil? 
    
    entry_datetime = self.entry_datetime  
    
    
    active_subcription = SubcriptionRegistration.where{
      (finish_subcription_date.gte entry_datetime) & 
      (start_subcription_date.lt entry_datetime) & 
      ( vehicle_registration_id.eq vehicle_registration.id )
    }.first 
    
    self.is_subcription = true 
    self.subcription_registration_id = active_subcription
    self.customer_id = vehicle_registration.customer_id 
    self.vehicle_id = vehicle_registration.vehicle_id 
    self.save 
  end
  
  def self.create_object( params ) 
    new_object           = self.new
  
    new_object.license_plate_no    =  ( params[:license_plate_no].present? ? params[:license_plate_no].to_s.upcase.gsub(/\s+/, "") : nil )  
    new_object.vehicle_case  = params[:vehicle_case]
    new_object.entry_datetime      = params[:entry_datetime    ] 
    if new_object.save
      new_object.generate_booking_code
      new_object.assign_subcription_registration 
    end
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    if self.is_printed?
      self.errors.add(:generic_errors, "Sudah di print")
      return self 
    end
    
    
    self.license_plate_no    =  ( params[:license_plate_no].present? ? params[:license_plate_no].to_s.upcase.gsub(/\s+/, "") : nil )  
    self.vehicle_case  = params[:vehicle_case]
    self.entry_datetime      = params[:entry_datetime    ] 
    
    if self.save
      self.assign_subcription_registration 
    end
    
    return self
  end
  
  def delete_object
    self.is_deleted = true 
    self.save 
  end 
  
  
  def self.active_objects
    self.where(:is_deleted => false ) 
  end
end
