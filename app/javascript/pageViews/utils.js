/**
 * Generates the fetch request options
 * @param {String} method - HTTP verb used (POST, DELETE, PATCH)
 * @param {*} body - request body
 * @returns {Object} - fetch options object
 */
const getRequestOptions = (method, body) => {
  const token = $('meta[name="csrf-token"').attr('content');
  const headers = new Headers();
  headers.append("Accept", "application/json");
  headers.append("Content-Type", "application/json");
  headers.append("X-CSRF-Token", token);
  const obj = { headers, method };
  if (body) {
    obj.body = JSON.stringify(body);
  }
  return obj;
};

/**
 * Wrapper function around fetch helper
 * @param {String} method - HTTP verb used
 * @returns {Function} - function that handles fetch request for given method,
 * handler function itself returns a Promise that resolves with parsed json response
 */
const fetchFactory = method => {
  return async (url, body) => {
    let res;
    if (method === "GET") {
      res = await fetch(url);
    } else {
      res = await fetch(url, getRequestOptions(method, body));
    }
    return await res.json();
  };
};

/**
 * A module for handling fetch requests
 * @namespace fetchHelpers
 */
export const fetchHelpers = {
  get: fetchFactory("GET"),
  post: fetchFactory("POST"),
  patch: fetchFactory("PATCH"),
  delete: fetchFactory("DELETE")
};

/**
 * format phone number input to this format 'dd-ddd-dd-dd'
 * @param {Object} $modal - jQuery Element of modal containing
 * the input field
 */
export const formatPhoneNumberInput = $modal => {
    $modal.find('.form')
    .form('get field', 'phone_number')
    .on("keyup", function () {
      let input = $(this).val();
      // forcing the phone number format
      input = input.replace(/(\d{2})(\d{3})(\d{2})(\d{2})/, "$1-$2-$3-$4");
      // keeping 12 first characters 'dd-ddd-dd-dd'
      input = input.slice(0, 12);
      $(this).val(input);
    });
}

/**
 * Intializes/configures given modal
 * @param {Objecy} $modal - jQuery Modal element
 * @param {Objecy.<Functions>} events - Modal (hide, approve, deny) events handlers
 * @returns {Object} intialized modal
 */
export const initializeModal = ($modal, { onHideCB, onApproveCB, onDenyCB, onHiddenCB, ...others={} } = {}) => {
  return $modal.modal({
    ...others,
    selector: {
      close: ".actions .close"
    },
    onHide() {
      console.log("on hide");
      if (onHideCB) onHideCB($modal);
    },
    onDeny() {
      console.log("on deny");
      if (onDenyCB) onDenyCB($modal);
      return false;
    },
    onApprove() {
      if (onApproveCB) onApproveCB($modal);
      return false;
    },
    onHidden() {
      console.log("hidding modal");
    }
  });
}

const AVAILABLE_ROUTES = [
  'appointments',
  'employees',
  'customers',
  'services',
  'users'
];

/**
 * Returns baseURL of all api endpoints
 * @param {Number|String} salonId - Currenly displayed salon ID
 * @returns {Object}
 */
export const getBaseRoutes = (salonId) => {
  const obj = {};
  for(const route of AVAILABLE_ROUTES) {
    obj[route] = `/api/v1/salons/${salonId}/${route}`
  }
  return obj;
}


export const COLORS = [
  ["violet", "#6435c9"],
  ["olive", "#b5cc18"],
  ["teal", "#00b5ad"],
  ["purple", "#a333c8"],
  ["red", "#db2828"],
  ["orange", "#f2711c"],
  ["yellow", "#fbbd08"],
  ["green", "#21ba45"],
  ["brown", "#a5673f"],
  ["blue", "#2185d0"],
  ["pink", "#e03997"],
  ["black", "#000000"]
]