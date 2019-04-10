import "fullcalendar/dist/locales/fr";
import { Calendar } from "fullcalendar";
import { fetchHelpers, formatPhoneNumberInput, initializeModal, getBaseRoutes, COLORS } from "./utils";

/**
 * We use function notation to allow for the
 * 'this' context inside of the function to
 * be the same as the 'this' we give when we call it
 */
const fullCalendarConfig = function () {
  return {
    header: {
      left: "title",
      center: "agendaDay,agendaWeek,month",
      right: "prev,next today"
    },
    locale: "fr",
    allDaySlot: false,
    navLinks: true, // can click day/week names to navigate views
    editable: true,
    themeSystem: "standard",
    defaultView: "month",
    eventLimit: true, // allow "more" link when too many events
    minTime: '08:00:00',
    maxTime: '22:00:00',
    nowIndicator: true,
    events: (info, yayCB, nayCB) => {
      this._getAppointments()
        .then(yayCB)
        .catch(nayCB);
    },
    dateClick: info => {
      const $modal = this.$addAppointmentModal;
      const $dateField = $modal.find(".date-calendar--js");
      const $timeField = $modal.find(".time-calendar--js");

      const date = new Date(
        info.date.getFullYear(),
        info.date.getMonth(),
        info.date.getDate()
      );

      // we show modal before initalizing f-ui calendar
      $modal.modal("show");

      // checking the first value of the checkbox 'Validé'
      $modal.find(".ui.checkbox").first()
        .checkbox('check');

      $dateField.calendar({
        text: frenchCalendarText,
        type: "date"
      }).calendar("set date", date, true, false);

      $timeField.calendar({
        type: "time",
        ampm: false
      });
    },
    eventClick: info => {
      const $modal = this.$modifyAppointmentModal;
      const data = info.event.extendedProps;

      const $form = $modal.find(".ui.form");
      const valuesObj = {
        first_name: data.customer.first_name,
        last_name: data.customer.last_name,
        phone_number: data.customer.phone_number.slice(4),
        email: data.customer.email,
        address: data.customer.address,
        service_category: data.service.category,
        service_id: data.service.id
      };

      if (data.appointment.employee && data.appointment.employee.id !== undefined) {
        valuesObj["employee_id"] = data.appointment.employee.id;
      }

      $form.form("set values", valuesObj);

      $modal.modal("show");

      if (!this._dateFields) {
        this._dateFields = {
          $date: $form.find(".date-calendar--js"),
          $time: $form.find(".time-calendar--js")
        };
      }
      const date = new Date(data.appointment.start_appointment);

      this._dateFields.$date.calendar({
        text: frenchCalendarText,
        type: "date"
      }).calendar("set date", date);

      this._dateFields.$time.calendar({
        type: "time",
        ampm: false
      }).calendar("set date", date);

      $form
        .find(`.checkbox input[value="${data.appointment.status}"]`)
        .parent().checkbox("check");

      this._currentEventId = data.appointment.id;

      info.jsEvent.preventDefault();
    }
  };
};

/**
 * Calendar input is in english by default
 * so we need to fill in the calendar in french
 */
const frenchCalendarText = {
  days: ["D", "L", "M", "M", "J", "V", "S"],
  months: [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre"
  ],
  monthsShort: [
    "Jan",
    "Fev",
    "Mar",
    "Avr",
    "Mai",
    "Juin",
    "Juil",
    "Aou",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ],
  today: "Aujourd'hui",
  now: "Maintenant",
  am: "AM",
  pm: "PM"
};

const appointmentFormConfig = ({ onSuccessCB, onFailureCB } = {}) => ({
  fields: {
    "first_name": "empty",
    "last_name": "empty",
    "phone_number": "regExp[/^\\d\\d-\\d\\d\\d-\\d\\d-\\d\\d$/]",
    "service_category": "empty",
    "service_id": "empty",
    "time_validate": "empty"
  },
  onSuccess() {
    if (onSuccessCB) onSuccessCB($(this));
  },
  onFailure() {
    if (onFailureCB) onFailureCB($(this));
  }
});

export default class AppointmentsCalendar {
  constructor(salonId) {
    this.$container = $(".view.calendar-js");
    this.calendarContainer = document.getElementById("calendar");
    // Frequently used elements
    this.$addAppointmentModal = $("#add-appointment--modal");
    this.$modifyAppointmentModal = $("#modify-appointment--modal");
    this.$confirmDeleteModal = $("#confirm-appointment-delete-modal");
    this.salonId = salonId;

    this.routes = getBaseRoutes(this.salonId);
  }

  /**
   * Initializes full calendar
   */
  async _initializeCalendar() {
    if (!this.calendar) {
      this.calendar = new Calendar(
        this.calendarContainer,
        fullCalendarConfig.call(this)
      );
      this.calendar.render();
    }
    else
      this.calendar.refetchEvents();
  }

  /**
   * Initializes appointment forms ui components with
   * appropriate settings (when required)
   */
  _initializeAppointmentForms() {

    this._initializeAddAppointmentForms();

    this._initializeModifyAppointmentForms();

    this._populateServiceDropdowns();
  }

  /**
   * Initializes add appointment form ui components
   * with appropriate settings (when required)
   */
  _initializeAddAppointmentForms() {

    initializeModal(this.$addAppointmentModal, {
      onApproveCB: $modal => {
        $modal
          .find(".form")
          .form("validate form");
      }
    });

    this.$addAppointmentModal.find('.form')
      .form(appointmentFormConfig({
        onSuccessCB: async ($form) => {
          const body = this._getAppointmentFormData($form);

          try {
            await this._createAppointment(body);
            // closing parent modal
            $form.closest('.ui.modal').modal("hide");
          } catch (err) {
            console.log(err);
          }
        }
      }));

    formatPhoneNumberInput(this.$addAppointmentModal);

  }

  /**
   * Initializes modify appointment form ui components
   * with appropriate settings (when required)
   */
  _initializeModifyAppointmentForms() {
    initializeModal(this.$modifyAppointmentModal, {
      allowMultiple: true,
      onApproveCB: async $modal => {
        $modal
          .find(".form")
          .form("validate form");
      },
      onDenyCB: $modal => {
        this.$confirmDeleteModal.modal("show");
      }
    });

    this.$modifyAppointmentModal.find('.form')
      .form(appointmentFormConfig({
        onSuccessCB: async ($form) => {
          const body = this._getAppointmentFormData($form);
          try {
            await this._updateAppointment(this._currentEventId, body);
            $form.closest('.ui.modal').modal("hide");
          } catch (err) {
            // some prompting can be done here
            console.log(err);
          }
        }
      }));

    formatPhoneNumberInput(this.$modifyAppointmentModal);

    initializeModal(this.$confirmDeleteModal, {
      allowMultiple: true,
      onApproveCB: async ($modal) => {
        try {
          await this._removeAppointment(this._currentEventId);
          $modal.modal("hide");
          setTimeout(() => {
            this.$modifyAppointmentModal.modal("hide");
          }, 450);
        } catch (err) {
          // some prompting can be done here
          console.log(err);
        }
      },
      onDenyCB($modal) {
        $modal.modal("hide");
      }
    });

    this._populateEmployeesDropdown();

    this._populateServiceDropdowns();
  }

  /**
   * extracts appointment form data
   */
  _getAppointmentFormData($form) {
    // get values from form fields
    const formValues = $form.form("get values");
    // we get the date and time field manually
    const d = $form.find(".date-calendar--js").calendar("get date");
    const t = $form.find(".time-calendar--js").calendar("get date");

    const date = new Date(d);
    date.setHours(t.getHours());
    date.setMinutes(t.getMinutes());

    // making a clone of the formValues object
    const data = Object.assign({},
      {
        "customer":
        {
          "first_name": formValues["first_name"],
          "last_name": formValues["last_name"],
          "email": formValues["email"],
          "address": formValues["address"],
          "phone_number": `+221 ${formValues["phone_number"]}`
        },
        "appointment": {
          "start_appointment": date,
          "service_id": formValues["service_id"],
          "status": formValues["status"],
          "employee_id": formValues["employee_id"]
        }
      });

    return data;
  }

  /**
   * Fetches & populates service dropdown items dynamically
   */
  async _populateServiceDropdowns() {
    // fetch services from api
    const categories = await fetchHelpers.get(
      this.routes.services
    );

    // setting categories attribute
    this._categories = categories.data;

    // generate service category items values
    var tableau = [];
    const tab = categories.data.map(val => {
      tableau.push(val.attributes.category);
    });
    const test = [...new Set(tableau)];
    test.sort();
    const dropdownCatVals = test.map(val => ({ name: val, value: val }))


    // populate service categories dropdowns
    $(".service-category--js").dropdown({
      placeholder: "Catégories",
      values: dropdownCatVals,
      onChange(value) {
        // get parent form
        const $parentForm = $(this).closest(".form");
        // get sibling dropdown (service name dropdown)
        const $servicesDropdown = $parentForm.find(".service-name--js");
        // generate category services items values
        const dropdownSerVals = categories.data
          .filter(service => value === service.attributes.category)
          .map(service => ({
            name: service.attributes.name + " " + service.attributes.price_cents + " " + service.attributes.money,
            text: service.attributes.name + " " + service.attributes.price_cents + " " + service.attributes.money,
            value: service.attributes.id.toString()
          }
          ));
        $servicesDropdown.dropdown("change values", dropdownSerVals);
      }
    });
  }

  async _populateEmployeesDropdown() {
    if (!this._employees || !this._employees.length) {
      await this._getEmployees();
    }
    $(".employee-name--js")
      .dropdown(
        "change values",
        this._employees
          .map(e => ({
            value: e.id,
            name: `${e.attributes.first_name} ${e.attributes.last_name}`
          }))
      );
  }


  /**
   * Get employees from database and assign a unique
   * color to each one them
   */
  async _getEmployees() {
    const employees = (await fetchHelpers.get(this.routes.employees)).data;
    this._employees = employees.map((employee, i) => ({
      ...employee,
      color: COLORS[i]
    }));
  }

  async _initilizeEmployeesColorLabels() {
    try {
      await this._getEmployees();

      const labelsHTML = this._employees.map(employee => (`
      <div class="ui image label ${employee.color[0]}">
        ${employee.attributes.first_name}
      </div>
      `)).join('');
      this.$container.find('.employees-labels--js').html(labelsHTML);
    } catch (err) {
      console.log(err);
    }
  }


  /**
   * POSTs appointment data to database and shows appointment
   * on calendar
   * @param {Object} body - data object to send in fetch body
   */
  async _createAppointment(body) {
    const response = await fetchHelpers.post(
      this.routes.appointments,
      body
    );

    // refetching events on create
    this.calendar.refetchEvents();
  }

  /**
   * PATCHs appointment data to database and shows appointment
   * on calendar
   * @param {String|Number} id - appointment id to update
   * @param {Object} body - data object to send in fetch body
   */
  async _updateAppointment(id, body) {
    const response = await fetchHelpers.patch(
      `${this.routes.appointments}/${id}`,
      body
    );

    // refetching events on update
    this.calendar.refetchEvents();
  }

  /**
   * DELETEs appointment from DataBase and Fullcalendar
   * @param {String|Number} id - appointment id to delete
   */
  async _removeAppointment(id) {
    await fetchHelpers.delete(
      `${this.routes.appointments}/${id}`,
    );

    // refetching events on delete
    this.calendar.refetchEvents();
  }

  /**
   * GETs all appointments from DB, structers them as eventSource Objects Array
   * @returns {Array.<Object>} eventSource Objects Array
   */
  async _getAppointments() {
    const response = await fetchHelpers.get(
      this.routes.appointments
    );
    const events = [];
    response.data.forEach(item => {

      const employee = this._employees.find(e => {
        if (item.attributes.employee) {
          return e.attributes.id === item.attributes.employee.id
        }
        return false;
      });

      const color = employee ? employee.color[1] : "grey";

      const epObj = Object.assign({}, {
        appointment: item.attributes,
        customer: item.attributes.customer,
        service: item.attributes.service
      });

      events.push({
        id: epObj.appointment.id,
        title: `${epObj.service.category}/${epObj.customer.first_name}`,
        start: new Date(epObj.appointment.start_appointment),
        end: new Date(epObj.appointment.end_appointment),
        extendedProps: epObj,
        backgroundColor: color,
        borderColor: color
      });
    });
    return events;
  }

  /**
   * Adds eventSource object to calendar
   */
  addEventToCalendar(data) {
    // extract service with the given service_id

    this.calendar.addEvent({
      id: data.appointment.id,
      title: `${data.service.category}/${data.customer.first_name}`,
      start: new Date(data.appointment.start_appointment),
      end: new Date(data.appointment.end_appointment),
      extendedProps: data
    });
  }

  init() {
    this._employees = null;
    this._initilizeEmployeesColorLabels();
    this._initializeCalendar();
    this._initializeAppointmentForms();
  }
}