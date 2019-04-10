import { fetchHelpers, formatPhoneNumberInput, initializeModal, getBaseRoutes } from "./utils";

const getEmployeeCardHTML = employee => {
  return `
<div class="ui raised card" data-employee_id="${employee.attributes.id}">
<div class="content">
  <img class="right floated mini circular ui image" src="../../../assets/mat.png">
  <div class="header" style="box-shadow:none!important;">
    ${employee.attributes.first_name} ${employee.attributes.last_name}
  </div>
  <div class="description">

    <div class="ui list">
      <div class="item">
        <i class="marker teal fitted icon"></i>
        <div class="content">
          ${employee.attributes.address || "N/A"}
        </div>
      </div>
      <div class="item">
        <i class="mobile teal fitted icon"></i>
        <div class="content">
          ${employee.attributes.phone_number}
        </div>
      </div>
      <div class="item">
        <i class="envelope teal fitted icon"></i>
        <div class="content">
          ${employee.attributes.email || "N/A"}
        </div>
      </div>
    </div>
  <div class="ui basic labels">
    <span class="ui label">
      Fun
    </span>
    <span class="ui label">
      Happy
    </span>
    <span class="ui label">
      Smart
    </span>
  </div>
  </div>
</div>
<div class="extra content">
  <span class="ui left floated delete-employee--js">
    <i class="trash alternate outline icon" style="color:#e72c4f;"></i>
    delete
  </span>
  <span class="ui right floated edit-employee--js">
    <i class="cog icon" style="color:#4095cd;"></i>
    edit
  </span>
</div>
</div>`;
};


const employeeFormConfig = ({onSuccessCB, onFailureCB} = {}) => ({
  fields: {
    "first_name": "empty",
    "last_name": "empty",
    "phone_number": "regExp[/^\\d\\d-\\d\\d\\d-\\d\\d-\\d\\d$/]"
  },
  onSuccess() {
    if(onSuccessCB) onSuccessCB($(this));
  },
  onFailure() {
    if(onFailureCB) onFailureCB($(this));
  }
});

export default class EmployeesList {
  constructor(salonId) {
    this.$employeesCardsContainer = $("#employees");
    this.$addEmployeesFormModal = $('#add-employee--modal');
    this.$confirmDeleteModal = $("#confirm-employee-delete-modal");
    this.salonId = salonId;
    this.routes = getBaseRoutes(this.salonId);
  }

  /**
   * Initializes customers datatable
   */
  async _createEmployeesCards() {
    this._employees = await this._getEmployees();

    const employeeHtmlList = this._employees.data.map(getEmployeeCardHTML);
    this.$employeesCardsContainer.html(employeeHtmlList.join(""));
    // Add event listener to employee delete 'button'
    this.$employeesCardsContainer
      .find(".delete-employee--js")
      .on("click", this._handleEmployeeDeleteBtnClick.bind(this));
  }

  _initializeEmployeesForms() {
    // initialize modal and attach show event to
    // 'add-employee-btn--js' button
    initializeModal(this.$addEmployeesFormModal, {
      onApproveCB: async ($modal) => {
        $modal
          .find('.form')
          .form("validate form");
      }
    })
    .modal('attach events', '.add-employee-btn--js', 'show');

    this.$addEmployeesFormModal
      .find('.form')
      .form(employeeFormConfig({
        onSuccessCB: async ($form) => {
          const data = this._getEmployeeFormData($form);
          try {
            await this._createNewEmployee(data);
            $form.closest('.ui.modal').modal("hide");
          } catch(err) {
            // some prompting can be done here
            console.log(err);
          }
        }
      }));

    formatPhoneNumberInput(this.$addEmployeesFormModal);

    initializeModal(this.$confirmDeleteModal, {
      onApproveCB: async ($modal) => {
        if(!this._employeeIdToDelete) return;
        await this._deleteEmployee(this._employeeIdToDelete);
        $modal.modal("hide");
      },
      onDenyCB($modal) {
        $modal.modal("hide");
      },
      onHiddenCB() {
        this._employeeIdToDelete = null;
      }
    });
  }

  /**
   * extract data from given (jQuery) form element
   * @param {Object} $form - (jQuery) form element to get data from
   */
  _getEmployeeFormData($form) {
    const data = $form.form("get values");
    data.phone_number = `+221 ${data.phone_number}`;
    return data;
  }

  _handleEmployeeDeleteBtnClick(event) {
    const $employeeCard = $(event.target).closest(".ui.card");
    const employeeId = $employeeCard.attr("data-employee_id");
    // we set the employee id to delete
    this._employeeIdToDelete = employeeId;
    this.$confirmDeleteModal.modal("show");
  }

  /**
   * gets all employees to DB
   * @returns {Array.<Objects>} - Array of employees data objects
   */
  async _getEmployees() {
    return await fetchHelpers.get(
      this.routes.employees
    );
  }

  /**
   * POSTs a new employee, adds it to _employees array
   * and Adds it to view
   * @param {Object} body - request body object
   * @returns {Object} - employee response object
   */
  async _createNewEmployee(body) {
    const employee = Object.assign({}, {
      employee : body,
    })
    const response = await fetchHelpers.post(
      this.routes.employees,
      employee
    );
    this.init();
  }

  /**
   * DELETEs employee from DB and employee card from DOM
   * @param {String|Number} id - Employee id to delete
   */
  async _deleteEmployee(id) {
    const response = await fetchHelpers.delete(
      `${this.routes.users}/${id}`
    );
    if(response.data.id && (Number(response.data.id) === Number(id))) {
      const $employeeCard = this.$employeesCardsContainer
        .find(`.card[data-employee_id="${id}"]`);
      $employeeCard.remove();
    }
  }

  init() {
    this._createEmployeesCards();
    this._initializeEmployeesForms();
  }
}
