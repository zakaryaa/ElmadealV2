json.attachments @services do |service|
  json.name service.name
  json.description service.description
  json.duration service.duration
  json.category service.category
  json.price_cents service.price_cents
end

