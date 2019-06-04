json.appointments  @appointments do |appointment|

  json.start_appointments appointment.start_appointments
  json.end_appointments service.end_appointments
  json.status appointment.status
  json.category appointment.category
  json.price_cents appointment.price_cents
end


