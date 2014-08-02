require 'rails_helper'
require 'capybara/rails'

feature "Getting information about users" do
  scenario "admins can see current members" do
    admin = create_user(is_admin: true)
    subscriber1 = create_user(name: "subscriber1", email: "subscriber1@example.com")
    subscriber2 = create_user(name: "subscriber2", email: "subscriber2@example.com")
    subscriber3 = create_user(name: "asubscriber", email: "asubscriber@example.com")
    non_subscriber = create_user(name: "non-subscriber", email: "non-subscriber@example.com")
    SubscriptionEvent.create!(user_id: subscriber1.id, event_type: "subscribed", price_per_month_in_cents: 100, date: 1.day.ago)
    SubscriptionEvent.create!(user_id: subscriber2.id, event_type: "changed", price_per_month_in_cents: 100, date: 1.day.ago)
    SubscriptionEvent.create!(user_id: subscriber3.id, event_type: "subscribed", price_per_month_in_cents: 100, date: 1.day.ago)
    SubscriptionEvent.create!(user_id: non_subscriber.id, event_type: "unsubscribed", date: 1.day.ago)

    visit root_path
    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_on "Login"

    click_link "Current Members"

    expect(page).to have_selector("table.current-members th", text: "Name")
    expect(page).to have_selector("table.current-members td.name:nth-child(1)", text: subscriber3.name)
    expect(page).to have_selector("table.current-members td.name:nth-child(1)", text: subscriber1.name)
    expect(page).to have_selector("table.current-members td.name:nth-child(1)", text: subscriber2.name)
    expect(page).to_not have_content(non_subscriber.name)
  end
end