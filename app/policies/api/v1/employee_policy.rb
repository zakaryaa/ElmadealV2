class Api::V1::EmployeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
