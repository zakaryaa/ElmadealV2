json.appointments  @appointments do |appointment|
  json.start_appointments appointment.start_appointments
  json.end_appointments appointment.end_appointments
  json.status appointment.status
end