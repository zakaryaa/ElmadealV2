class ServiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,:category,:name,:salon_id,:price_cents,:money
end