import "@babel/polyfill";
import jQuery from "jquery";
window.$ = window.jQuery = jQuery;
import "../vendors/semantic/dist/semantic.min.js";
import "moment";
import "datatables.net-se";

import AppointmentsCalendar from '../pageViews/calendar';
import ClientsDatatable from '../pageViews/clients';
import EmployeesList from '../pageViews/employees';


class App {
  constructor() {
    // dashboard
    this.$dashboardView = $(".view.dashboard");
    this.$dashboardViewButton = $("#view-btn-dashboard");
    // clients
    this.$clientsView = $(".view.clients");
    this.$clientsViewButton = $("#view-btn-clients");
    // calendar
    this.$calendarView = $(".view.calendar");
    this.$calendarViewButton = $("#view-btn-calendar");
    // employees
    this.$employeesView = $(".view.employees");
    this.$employeesViewButton = $("#view-btn-employees");

    this.$allViewButtons = $(".menu-item");

    this.$currentView = this.$dashboardView;
    this.salonId = $('.dropdown-btn-js').data("salon-id");

    // intialize appointements calendar
    this.appointmentsCalendar = new AppointmentsCalendar(this.salonId);
    this.clientsDatatable = new ClientsDatatable(this.salonId);
    this.employeesList = new EmployeesList(this.salonId);
  }

  /**
   * Toggles side menu display on hamburger menu button click
   */
  toggleSideMenu() {
    const $sideMenuToggleButton = $(".hamburger-js");
    const $sideMenu = $(".side-menu-js");
    const $hamburgerIcon = $sideMenuToggleButton.find(".icon");

    $sideMenuToggleButton.on("click", () => {
      $sideMenu.toggleClass("shrunken");

      if ($sideMenu.hasClass("shrunken")) {
        $hamburgerIcon.attr("class", "align left icon");
      } else {
        $hamburgerIcon.attr("class", "align justify icon");
      }
    });
  }


  _handleViewSwitch($targetButton, $toShowView, callback) {
    $targetButton.on("click", () => {
      if ($toShowView.hasClass("visible")) {
        return;
      }
      $targetButton.addClass("active");
      this.$currentView.removeClass("visible");
      this.$allViewButtons.each((i, viewBtn) => {
        // if button is not disabled
        if (!$(viewBtn).hasClass("disabled")) {
          $(viewBtn).removeClass("active");
        }
      });

      $targetButton.addClass("active");
      $toShowView.addClass("visible");
      this.$currentView = $toShowView;

      if (callback) callback();
    });
  }

  /**
   * Swtiches between page views (Dashboard, clients, ...)
   */
  switchViews() {
    // handler calendar view button click
    this._handleViewSwitch(
      this.$dashboardViewButton,
      this.$dashboardView
    );
    // handler calendar view button click
    this._handleViewSwitch(
      this.$calendarViewButton,
      this.$calendarView,
      this.appointmentsCalendar.init.bind(this.appointmentsCalendar)
    );
    // handler clients view button click
    this._handleViewSwitch(
      this.$clientsViewButton,
      this.$clientsView,
      this.clientsDatatable.init.bind(this.clientsDatatable)
    );
     // handler clients view button click
    this._handleViewSwitch(
      this.$employeesViewButton,
      this.$employeesView,
      this.employeesList.init.bind(this.employeesList)
    );
  }

  init() {
    this.toggleSideMenu();
    $('.nav .dropdown').dropdown();
    this.switchViews();

  }
}

$(document).ready(() => {
  const app = new App();
  app.init();
});
