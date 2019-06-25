json.roles @roles do |role|
  json.id role.id
  json.role role.role
  json.name  role.user.first_name + " " + role.user.last_name
end