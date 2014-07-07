class Ticket < ActiveRecord::Base
   
  validates_presence_of :license_plate_no, :vehicle_case , :entry_datetime   
  
  validate :valid_vehicle_case 
  validate :no_double_active_license_plate_number
   
  def valid_vehicle_case
    return if not vehicle_case.present? 
    if not [
              VEHICLE_CASE[:car],
              VEHICLE_CASE[:motor]].include?( vehicle_case  ) 
              
      self.errors.add(:vehicle_case , "Harus ada jenis kendaraan")
      return self
    end
  end
  
  def no_double_active_license_plate_number
    return if not license_plate_no.present?  
    
    ordered_detail_count  = Ticket.where(
      :license_plate_no => license_plate_no,
      :is_deleted => false , 
      :is_exit => false 
    ).count 
    
    ordered_detail = Ticket.where(
      :license_plate_no => license_plate_no,
      :is_deleted => false , 
      :is_exit => false
    ).first
    
    if self.persisted? and ordered_detail.id != self.id   and ordered_detail_count == 1
      self.errors.add(:license_plate_no, "Sudah ada kendaraan dengan nomor #{license_plate_no}")
      return self 
    end
    
    # there is item with such item_id in the database
    if not self.persisted? and ordered_detail_count != 0 
      self.errors.add(:license_plate_no, "Sudah ada kendaraan dengan nomor #{license_plate_no}")
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
  
  def print
    self.is_printed = true
    self.save 
  end
  
  
  def validate_exit_conditions
    # must have base price rule 
    # 
    base_price_rule = PriceRule.where(
        :vehicle_case => self.vehicle_case, 
        :is_deleted => false, 
        :is_base_price => true ).first
        
    if base_price_rule.nil?
      self.errors.add(:generic_errors, "harus ada base price rule")
      return self 
    end
  end
  
  def assign_price_payable
    
    duration = self.exit_datetime - self.entry_datetime
    minutes = (duration * 24 * 60).to_i    
    
    total_number_of_hours =  (minutes.to_f / 60).ceil\
    
    base_price_rule = PriceRule.where(
        :vehicle_case => self.vehicle_case, 
        :is_deleted => false, 
        :is_base_price => true ).first
        
    specific_price_rules = PriceRule.where(
        :vehicle_case => self.vehicle_case, 
        :is_deleted => false ,
        :is_base_price => false ).order("hour ASC")
    
    amount = BigDecimal("0")
    (1..duration).each do |hour|
      
      specific_price_rule = specific_price_rules.where(:hour => hour).first 
      selected_price_rule = base_price_rule 
      selected_price_rule = specific_price_rule if specific_price_rule
      
      PriceRuleUsage.create_object(
        :ticket_id => self.id,
        :price_rule_id => selected_price_rule.id 
      )
      
      amount += selected_price_rule.price
      
    end
    
    self.price = amount
    self.save 
    
    
  end
  
  
  def exit_parking( params ) 
    if not self.is_printed?
      self.errors.add(:generic_errors, "Belum ada pencetakan tiket parkir")
      return self
    end
    
    if self.is_exit?
      self.errors.add(:generic_errors, "Sudah exit")
      return self
    end
    
    if self.is_deleted?
      self.errors.add(:generic_errors, "Sudah dihapus")
      return self 
    end
    
    self.is_exit = true
    self.exit_datetime = params[:exit_datetime]
    self.validate_exit_conditions
    if self.errors.size == 0 and  self.save 
      self.assign_price_payable
    end
  end
  
  def pay( params ) 
  end
  
  def delete_object
    self.is_deleted = true 
    self.save 
  end 
  
  
  def self.active_objects
    self.where(:is_deleted => false ) 
  end
end
