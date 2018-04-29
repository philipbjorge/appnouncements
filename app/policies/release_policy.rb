class ReleasePolicy < ApplicationPolicy
  def create?
    user.id == record.app.user_id
  end
end