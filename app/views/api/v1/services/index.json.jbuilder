json.services @services do |service|
  json.name service.name
  json.description service.description
  json.duration service.duration
  json.category service.category
  json.price_cents service.price_cents

  if(!service.promotion.nil?)
    promotion_price =  service.price_cents *  (service.promotion.percentage / 100)
    promotion_percentage = service.promotion.percentage
    json.promotion_price promotion_price
    json.promotion_percentage promotion_percentage
  end
end

