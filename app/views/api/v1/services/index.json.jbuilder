json.services @services do |service|
  json.id service.id
  json.name service.name
  json.description service.description
  json.duration service.duration
  json.category service.category
  json.price_cents service.price_cents
  promotion_price = 0
  promotion_percentage = 0
  service_price = 0
  if( !service.promotions.last.nil? )
    promotion_price =  service.price_cents *  service.promotions.last.percentage / 100
    promotion_percentage = service.promotions.last.percentage
    service_price = ( service.price_cents - promotion_price)
  end

  json.promotion_price promotion_price
  json.promotion_percentage promotion_percentage
  json.service_price service_price
end

