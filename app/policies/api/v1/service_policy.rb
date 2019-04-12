class Api::V1::ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
