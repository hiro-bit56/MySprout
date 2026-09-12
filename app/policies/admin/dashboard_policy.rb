class Admin::DashboardPolicy < ApplicationPolicy
  def index?
    user.admin
  end
end