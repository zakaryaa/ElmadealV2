class SalonSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,:name,:description,:address,:city,:phone_number
end
