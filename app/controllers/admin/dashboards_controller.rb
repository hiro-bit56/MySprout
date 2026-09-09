class Admin::DashboardsController < Admin::ApplicationController
  layout "admin"

  def index
    authorize :dashboard, policy_class: Admin::DashboardPolicy
  end

end