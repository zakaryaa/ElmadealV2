class Api::V1::BaseApiController < ActionController::Api
  include ActionController::MimeResponds
  respond_to :json
end
