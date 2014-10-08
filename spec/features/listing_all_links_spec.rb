require 'spec_helper'

feature "User browses the list of links" do 

  before(:each) {
    Link.create(:url => "http://www.makersacademy.com",
                :title => "Makers Academy",
                :tags => [Tag.first_or_create(:text => 'education')])
    Link.create(:url => "http://www.google.com",
                :title => "The Google", 
                :tags => [Tag.first_or_create(:text => 'search')])
    Link.create(:url => "http://www.bing.com", 
                :title => "The Bing",
                :tags => [Tag.first_or_create(:text => 'search')])
    Link.create(:url => "http://www.code.org",
                :title => "Code.org",
                :tags => [Tag.first_or_create(:text => 'education')])
  }

  scenario "when opening the home page" do 
    visit '/'
    expect(page).to have_content("Makers Academy")
  end

  scenario "filtered by a tag" do 
    visit '/tags/puppies'
    expect(page).not_to have_content("Makers Academy")
    expect(page).not_to have_content("Code.org")
    expect(page).not_to have_content("The Bing")
    expect(page).not_to have_content("The Google")

  end



end