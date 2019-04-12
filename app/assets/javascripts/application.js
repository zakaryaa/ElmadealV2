//= require rails-ujs
//= require_tree .
//= require jquery
//= require bootstrap-sprockets

//= require moment
//= require fullcalendar
//= require fullcalendar/locale-all

//= require select2

//= require Chart.min

var app = {};

function initDateTimePicker() {
  $("#datetimepicker2").datetimepicker({
    inline: true,
    sideBySide: true,
    format: "DD-MM-YYYY HH:mm"
  });
  //$('#datetimepicker2').data("DateTimePicker").defaultDate();
  var startDate = new Date();

  //$('#datetimepicker2').data({date: startDate}).datetimepicker('update').children("input").val(startDate);
}

var activeInactiveWeekends = false;

$("input[type=checkbox]").on("change", function() {
  if ($(".showHideWeekend").is(":checked")) {
    activeInactiveWeekends = true;
    $("#calendar").fullCalendar("option", {
      weekends: activeInactiveWeekends
    });
  } else {
    activeInactiveWeekends = false;
    $("#calendar").fullCalendar("option", {
      weekends: activeInactiveWeekends
    });
  }
});

$("#calendar").fullCalendar({
  header: {
    left: "today, printButton",
    center: "prev, title, next",
    right: "month,agendaWeek,agendaDay,listWeek"
  },
  views: {
    workWeek: {
      type: "month",
      weekends: false
    },
    weekends: {
      type: "month"
    }
  },
  height: 550,
  aspectRatio: 2,
  allDaySlot: true,
  displayEventTime: true,
  displayEventEnd: false,
  firstDay: 1,
  weekNumbers: true,
  weekNumberCalculation: "ISO",
  eventLimit: true,
  navLinks: true,
  defaultDate: moment(),
  timeFormat: "H(:mm)",
  editable: true,
  minTime: "08:00:00",
  maxTime: "18:00:00",
  weekends: true,
  dayClick: handleCalendarDayClick,
  events: function(start, end, timezone, callback) {
    getCalendarContent(callback);
  }
});

function handleCalendarDayClick(startDate, allDay, jsEvent, view) {
  var dd = startDate.format("YYYY-MM-DD").toString() + " 08:00:00";
  if (startDate.format("HH:mm:ss").toString() == "00:00:00") {
    startDate = moment(startDate.format("YYYY-MM-DD").toString() + " 08:00:00");
  } else {
    datetimeS = startDate;
  }

  $("#time-picker").val(startDate.format());
  $("#start_appointment").val(startDate.format("DD/MM/YYYY à HH:mm"));

  $("#time-picker").val(startDate.format());

  $("#datetimepicker2").data("date", startDate.format());
  $(".modal").modal("show");
  initDateTimePicker();
}

function getCalendarContent(callback) {
  $.get("/calendar/calendarcontent")
    .done(function(data) {
      var events = [];
      for (var key in data) {
        if (data.hasOwnProperty(key)) {
          events.push(getEventObject(data[key]));
        }
      }
      console.log(events);
      callback(events);
    })
    .fail(function() {});
}

function getEventObject(dataObj) {
  var appointment = dataObj["appointment"];
  var service = dataObj["service"];
  var user = dataObj["user"];

  var title = user["first_name"] + user["last_name"] + "/" + service["name"];

  var startDate = new Date(appointment["start_appointment"]);

  return {
    start: startDate.toISOString(),
    id: appointment["id"],
    title: title
  };
}



// factory function immediately invoked,
// function name for debugging
(function handleBookingFormSubmit() {
  var $form = $("#booking-form");
  $form.on("submit", function(event) {
    // prevent default behavior of form (refresh on submit)
    event.preventDefault();
    var appointmentData = {};
    $form.serializeArray().forEach(data => {
      appointmentData[data.name] = data.value;
    });

    appointmentData['service_id'] = $('select[name="service_id"]').val();
    
    $.post("calendar/calendarcontent", {"data" : appointmentData}).done((data) => { 
      console.log(data);
      var title =
      appointmentData["last_name"] +
      "/" +
      appointmentData["category"] +
      "/" +
      appointmentData["phone_number"];

      var startDate = new Date(appointmentData["start_appointment"]);
      var eventObj = {
        start: startDate.toUTCString(),
        title: title,
        color: "#000",
        textColor: "#fff"
      };
  
      $(".modal").modal("hide");
      $("#calendar").fullCalendar("renderEvent", eventObj, true);
    });
   
  });
})();

(function highlightDayOnMouseover() {

  $("td.fc-day").mouseover(function() {
    $(this).addClass("fc-highlight");
	});

  $("td.fc-day-top").mouseover(function() {
    var strDate = $(this).data("date");
    $(".fc-bg .fc-day")
      .filter("[data-date='" + strDate + "']")
      .addClass("fc-highlight");
	});

  $("td.fc-day").mouseout(function() {
    $(this).removeClass("fc-highlight");
	});

  $("td.fc-day-top").mouseout(function() {
    var strDate = $(this).data("date");
    $(".fc-bg .fc-day")
      .filter("[data-date='" + strDate + "']")
      .removeClass("fc-highlight");
  });
})();

// Eventos

$(".filter").on("change", function() {
  $("#calendar").fullCalendar("rerenderEvents");
});

$("#type_filter").select2({
  placeholder: "Filter Services",
  allowClear: true
});

/*$("#calendar_filter").select2({
    placeholder: "Filter Employes",
    allowClear: true
});
*/

/*$("#starts-at, #ends-at").datetimepicker();*/

/* Charts */

function beforePrintHandler() {
  for (var id in Chart.instances) {
    Chart.instances[id].resize();
  }
}
beforePrintHandler();
var ctx1 = $("#topServices");
options = {
  responsive: true,
  maintainAspectRatio: false
};

data1 = {
  datasets: [
    {
      data: [18, 25, 78],
      backgroundColor: ["#eb4d4b", "#6ab04c", "#4834d4"]
    }
  ],
  labels: ["Service 1", "Service 2", "Service 3"]
};
var topServices = new Chart(ctx1, {
  type: "doughnut",
  data: data1,
  options: options
});

ctx2 = $("#turnOver");
dataTurnOver = {
  labels: [
    "Janv",
    "Fev",
    "Mar",
    "Avr",
    "Mai",
    "Juin",
    "Juillet",
    "Aout",
    "Septembre",
    "Octobre",
    "Novembre",
    "Decembre"
  ],
  datasets: [
    {
      label: "FCFA (mille)",
      backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
      data: [24, 22, 33, 38, 43]
    }
  ]
};

optionsTurnOver = {
  responsive: true,
  legend: { display: false },
  title: {
    display: false,
    text: "Chiffres d'affaire"
  },
  scales: {
    xAxes: [
      {
        barPercentage: 0.8,
        categoryPercentage: 0.8,
        gridLines: {
          offsetGridLines: true
        },
        stacked: true
      }
    ],
    yAxes: [
      {
        stacked: true
      }
    ]
  }
};

var turnover = new Chart(ctx2, {
  type: "bar",
  data: dataTurnOver,
  options: optionsTurnOver
});

$(document).ready(function() {
  var navListItems = $("div.setup-panel div a"),
    allWells = $(".setup-content"),
    allNextBtn = $(".nextBtn");

  allWells.hide();

  navListItems.click(function(e) {
    e.preventDefault();
    var $target = $($(this).attr("href")),
      $item = $(this);

    if (!$item.hasClass("disabled")) {
      navListItems.removeClass("btn-primary").addClass("btn-default");
      $item.addClass("btn-primary");
      allWells.hide();
      $target.show();
      $target.find("input:eq(0)").focus();
    }
  });

  allNextBtn.click(function() {
    var curStep = $(this).closest(".setup-content"),
      curStepBtn = curStep.attr("id"),
      nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]')
        .parent()
        .next()
        .children("a"),
      curInputs = curStep.find("input[type='text'],input[type='url']"),
      isValid = true;

    $(".form-group").removeClass("has-error");
    for (var i = 0; i < curInputs.length; i++) {
      if (!curInputs[i].validity.valid) {
        isValid = false;
        $(curInputs[i])
          .closest(".form-group")
          .addClass("has-error");
      }
    }

    if (isValid) nextStepWizard.removeAttr("disabled").trigger("click");
  });

  $("div.setup-panel div a.btn-primary").trigger("click");
});

(function() {
  var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

  $.ajaxSetup( {
    beforeSend: function ( xhr ) {
      xhr.setRequestHeader( 'X-CSRF-Token', token );
    }
  });
})();