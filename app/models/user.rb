require 'action_view'

class User < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  has_secure_password

  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  has_many :subscription_events

  def active?
    self.subscription_events.present?
  end

  def value
    result = 0
    latest_start = nil
    ending = nil
    price = nil

    if self.active?
      length = self.subscription_events.length
      self.subscription_events.each_with_index do |event, index|
        if event.event_type == "subscribed" && index == length-1
          latest_start = event.date
          price = event.price_per_month_in_cents
          ending = Date.today
          result += ((ending.year * 12 + ending.month) - (latest_start.year * 12 + latest_start.month)) * price
        elsif event.event_type == "subscribed"
          latest_start = event.date
          price = event.price_per_month_in_cents
        elsif event.event_type == "changed" && index == length-1
          ending = event.date
          result += ((ending.year * 12 + ending.month) - (latest_start.year * 12 + latest_start.month)) * price
          latest_start = event.date
          price = event.price_per_month_in_cents
          ending = Date.today
          result += ((ending.year * 12 + ending.month) - (latest_start.year * 12 + latest_start.month)) * price
        elsif event.event_type == "changed"
          ending = event.date
          result += ((ending.year * 12 + ending.month) - (latest_start.year * 12 + latest_start.month)) * price
          latest_start = event.date
          price = event.price_per_month_in_cents
        elsif event.event_type == "unsubscribed"
          ending = event.date
          result += ((ending.year * 12 + ending.month) - (latest_start.year * 12 + latest_start.month)) * price
        end
      end
    end

    (result.to_f / 100)
  end
end
