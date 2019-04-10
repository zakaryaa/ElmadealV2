class SalonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    !@user.roles.where(role: Role::OWNER).empty? && @record.roles.where(role: Role::OWNER).first.user == @user
  end

  def show?
    true
  end

  def create?
     true
  end

  def update?
    true
  end

  def destroy?
    record.user == user || user.admin # Only restaurant creator can update it
  end
end
