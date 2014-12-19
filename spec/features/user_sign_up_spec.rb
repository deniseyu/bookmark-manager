require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

feature "User signs in" do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => "test",
                :password_confirmation => "test")
  end

  scenario "with correct credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in("test@test.com", "test")
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do
    visit '/'
    sign_in("test@test.com", "not_test")
    expect(page).to have_content('The email or password is incorrect')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end
