class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,:email,:first_name,:last_name,:phone_number,:city,:address
end