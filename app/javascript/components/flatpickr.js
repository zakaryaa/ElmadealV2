$(function () {
  $('#datetimepicker1').datetimepicker({
    inline: true,
    sideBySide: true,
    locale: 'fr',
    format: 'DD-MM-YYYY HH:mm',
    stepping: 15,
    minDate: new Date()
  });
});

document.querySelectorAll(".btn-book").forEach((button) => {
  button.addEventListener('click', (e) => {
    const serviceId = button.dataset.serviceId;
    document.getElementById("customer-booking-form").setAttribute("action", `/appointments/${serviceId}`);
    const appointmentHour = document.querySelector('.timepicker-hour').innerText;
    const appointmentMinute = document.querySelector('.timepicker-minute').innerText;
    document.getElementById("time-picker").value = `${appointmentHour}:${appointmentMinute}`;
  })
})