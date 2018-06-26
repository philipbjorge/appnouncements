class AppPolicy < ApplicationPolicy
  def create?
    user.id == record.user_id
  end

  def update?
    user.id == record.user_id
  end

  def attach?
    user.id == record.user_id
  end

  def preview?
    user.id == record.user_id
  end
  
  def destroy?
    user.id == record.user_id
  end

  class Scope < Scope
    def resolve
      scope.where(user: @user)
    end
  end
end