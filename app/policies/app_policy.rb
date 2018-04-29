class AppPolicy < ApplicationPolicy
  def create?
    user.id == record.user_id
  end

  class Scope < Scope
    def resolve
      scope.where(user: @user)
    end
  end
end