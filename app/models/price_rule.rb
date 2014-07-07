class PriceRule < ActiveRecord::Base
   
  validates_presence_of :price, :hour  , :vehicle_case , :is_base_price
  

  validate :valid_vehicle_case 
  validate :no_overlap_for_non_base_rule
  
  
  def valid_vehicle_case
    return if not vehicle_case.present? 
    if not [
              VEHICLE_CASE[:car],
              VEHICLE_CASE[:motor]].include?( price_rule_case  ) 
              
      self.errors.add(:vehicle_case , "Harus ada jenis kendaraan")
      return self
    end
  end
  
  
  def no_overlap_for_non_base_rule
    return if not vehicle_case.present? 
    return if not is_base_price.present?
    return if  is_base_price? 
    return if not hour.present? 
     
    
    ordered_detail_count  = PriceRule.where(
      :vehicle_case => vehicle_case,
      :is_base_price  => false ,
      :is_deactivated => false ,
      :hour => hour 
    ).count 
    
    ordered_detail = PriceRule.where(
      :vehicle_case => vehicle_case,
      :is_base_price  => false ,
      :is_deactivated => false,
      :hour => hour 
    ).first
    
    if self.persisted? and ordered_detail.id != self.id   and ordered_detail_count == 1
      self.errors.add(:hour, "Sudah ada rule di jam parkir ke #{hour}")
      return self 
    end
    
    # there is item with such item_id in the database
    if not self.persisted? and ordered_detail_count != 0 
      self.errors.add(:hour, "Sudah ada rule di jam parkir ke #{hour}")
      return self
    end
  end
  
  
 
  
  def self.create_object( params ) 
    new_object           = self.new


    new_object.is_base_price = params[:is_base_price]  
    new_object.vehicle_case  = params[:vehicle_case]
    new_object.hour          = params[:hour    ] 
    new_object.price         = BigDecimal( params[:price] || '0')


    new_object.save
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    
    if self.price_rule_usages.count  != 0 
      self.errors.add(:generic_errors, "Sudah ada ticket yang menggunakan harga ini")
      return self 
    end
    
    self.is_base_price = params[:is_base_price]  
    self.vehicle_case  = params[:vehicle_case]
    self.hour          = params[:hour    ] 
    self.price         = BigDecimal( params[:price] || '0')
    
    self.save
    
    return self
  end
  
  def delete_object
    
    if self.price_rule_usages.count  != 0 
      self.errors.add(:generic_errors, "Sudah ada penggunaan price rule ini")
      return self
    end
    
    
    self.destroy
  end 
  
  
  def self.active_objects
    self.where(:is_deactivated => false)
  end
end
