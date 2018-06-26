class ReleasePolicy < ApplicationPolicy
  def update?
    user.id == record.app.user_id
  end

  def destroy?
    user.id == record.app.user_id
  end
end