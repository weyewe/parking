class SubcriptionProduct < ActiveRecord::Base
   
  validates_presence_of :duration, :name  , :price 
  validates_uniqueness_of :name  
  
  
  validate :valid_price
   
   
  has_many :vehicle_registrations, :through => :subcription_registrations 
  has_many :subcription_registrations 
  
  has_many :tickets 
  
  def valid_price
    return if not price.present?
    
    if price < BigDecimal("0")
      self.erros.add(:price, "Tidak boleh negative")
      return self 
    end
  end
  
  def valid_duration
    return if not duration.present?
    
    if duration <= 0 
      self.errors.add(:duration, "Durasi tidak boleh 0 atau negative")
      return self 
    end
  end
  
  
 
  
  def self.create_object( params ) 
    new_object          = self.new
    new_object.name     = params[:name]
    new_object.duration = params[:duration]
    new_object.description      = params[:description    ]
    new_object.price      =BigDecimal( params[:price] || '0')
    new_object.save
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    
    if self.is_deactivated?
      self.errors.add(:generic_errors, "Sudah non-aktif")
      return self
    end
    
    if self.subcription_registrations.count != 0 
      self.errors.add(:generic_errors, "Sudah ada pendaftaran customer dengan product ini. Tidak bisa update")
      return self 
    end
    
    
    self.name     = params[:name]
    self.duration = params[:duration]
    self.description      = params[:description    ]
    self.price      =BigDecimal( params[:price] || '0')
    
    self.save
    
    return self
  end
  
  def delete_object
    
    if self.is_deactivated?
      self.errors.add(:generic_errors, "Sudah non-aktif")
      return self 
    end
    
    if self.subcription_product_registrations.count !=  0
      self.errors.add(:generic_errors, "Sudah ada pendaftaran subcription_product terhadap customer")
      return self
    end
    
    if self.tickets.count != 0 
      self.errors.add(:generic_errors, "Sudah ada pendaftaran ticket")
      return self 
    end
    
    
    
    
    self.destroy
  end 
  
  def deactivate_object
    
    self.deactivated_at = params[:deactivation_date]
    self.is_deactivated = true 
    self.deactivation_description = params[:deactivation_description ]
    self.save 
    
  end
  
  
  def self.active_objects
    self.where(:is_deactivated => false )
  end
end
