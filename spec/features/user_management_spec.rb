require 'spec_helper'

feature "User signs up" do

  scenario "when being logged out" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq "alice@example.com"
  end

  scenario "with a password that doesn't match" do
    expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by 0
    expect(current_path).to eq '/users'
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario "with an email that is already registered" do
    expect{ sign_up }.to change(User, :count).by 1
    expect{ sign_up }.to change(User, :count).by 0
    expect(page).to have_content("This email is already taken")
  end

end

feature "User loses password" do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => "test",
                :password_confirmation => "test")
  end

  let(:user) { User.first }

  scenario "can click on a lost password link and see a new page where he is prompted for his email" do
    visit '/sessions/new'
    click_link 'Forgotten password?'
    expect(page).to have_content "Please enter your email"
  end

  scenario 'can retrieve his password by entering his email into the password retrieval form' do
    visit '/sessions/new'
    click_link 'Forgotten password?'
    fill_in 'email', :with => user.email
    click_button 'Submit'
    expect(page).to have_content 'Your password is on its way!'
  end

  # scenario "should receive an email" do
  #   User.any_instance.stub(:generate_token).and_return('hi')
  #   visit '/users/lost_password'
  #   fill_in 'email', :with => user.email
  #   click_button 'Submit'
  #   expect(user.password_token).to eq 'hi'
  #   expect(Time.parse(user.password_token_timestamp)).to be_within(10).of Time.now
  # end

  # scenario "and receives a reset key via email" do
  #   visit '/users/lost_password'
  #   fill_in 'email', :with => email
  #   click_button 'Submit'
  #   expect(user.send_simple_message).to
  # end


end