def create_user(overrides = {})
  User.create!({
    name: 'Some User',
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password'
  }.merge(overrides))
end

def create_subscription_event(user, overrides = {})
  SubscriptionEvent.create!({
    user_id: user.id,
    event_type: "subscribed",
    date: 1.day.ago,
    price_per_month_in_cents: 100
  }.merge(overrides))
end