class ReportsController < ApplicationController
  def current_members
    active_users = User.all.select { |user| user.active? }
    @current_members = active_users.select do |user|
      user.subscription_events.last.event_type == "subscribed" ||
        user.subscription_events.last.event_type == "changed"
    end
  end
end