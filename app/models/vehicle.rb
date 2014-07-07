class Vehicle < ActiveRecord::Base
   
  validates_presence_of :license_plate_no, :vehicle_case  
  validates_uniqueness_of :license_plate_no  
  
  has_many :customers, :through => :vehicle_registrations 
  has_many :vehicle_registrations
  
  validate :valid_vehicle_case 
  
  has_many :tickets 
  
  def valid_vehicle_case
    return if not vehicle_case.present? 
    if not [
              VEHICLE_CASE[:car],
              VEHICLE_CASE[:motor]].include?( vehicle_case  ) 
              
      self.errors.add(:vehicle_case , "Harus ada jenis kendaraan")
      return self
    end
  end
  
  
 
  
  def self.create_object( params ) 
    new_object           = self.new
  
    new_object.license_plate_no    =  ( params[:license_plate_no].present? ? params[:license_plate_no].to_s.upcase.gsub(/\s+/, "") : nil )  
    new_object.vehicle_case  = params[:vehicle_case]
    new_object.description      = params[:description    ] 
    new_object.save
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    self.license_plate_no    =  ( params[:license_plate_no].present? ? params[:license_plate_no].to_s.upcase.gsub(/\s+/, "") : nil )  
    self.vehicle_case  = params[:vehicle_case]
    self.description      = params[:description    ]
    
    self.save
    
    return self
  end
  
  def delete_object
    
    if self.vehicle_registrations.count !=  0
      self.errors.add(:generic_errors, "Sudah ada pendaftaran vehicle terhadap customer")
      return self
    end
    
    if self.tickets.count != 0 
      self.errors.add(:generic_errors, "Sudah ada pendaftaran ticket")
      return self 
    end
    
    self.destroy
  
  
    
  end 
  
  
  def self.active_objects
    self
  end
end
