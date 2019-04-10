import { fetchHelpers, getBaseRoutes } from "./utils";

export default class ClientsDatatable {
  constructor(salonId) {
    this.$clientsTableContainer = $("#clients");
    this.salonId = salonId;
    this.routes = getBaseRoutes(this.salonId);
    this._firstInit = true;
  }

  /**
   * Initializes customers datatable
   */
  async _initializeCustomersTable() {
    // const data = await this._fetchClients();
    if(!this._firstInit) {
      this.$clientsTableContainer.api().ajax.reload();
      return;
    }
    this.$clientsTableContainer.dataTable({
      processing: true,
      ajax: this.routes.customers,
      columns: [
        {
          data: "attributes.email",
          title: "Email"
        },
        {
          data: "attributes.first_name",
          title: "Nom"
        },
        {
          data: "attributes.last_name",
          title: "Prénom"
        },
        {
          data: "attributes.phone_number",
          title: "Teléphonne"
        },
        {
          data: "attributes.address",
          title: "Adresse"
        },
        {
          data: "attributes.city",
          title: "Ville"
        }
      ],
      deferRender: true
    });
    this._firstInit = false;
  }

  init() {
    this._initializeCustomersTable();
  }

  async _fetchClients() {
    return await fetchHelpers.get(this.routes.customers);
  }
}
