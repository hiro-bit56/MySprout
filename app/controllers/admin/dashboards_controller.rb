class Admin::DashboardsController < Admin::ApplicationController
  layout "admin"

  def index
    authorize :dashboard, policy_class: Admin::DashboardPolicy
    @dashboard = Admin::Dashboard.new
  end

end