require 'spec_helper'

describe "leases" do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
  end
  describe "create a new leased object" do

    let(:future_date) { 2.days.from_now }

    it "can be created, displayed and updated" do
      visit '/'
      click_link 'New Generic Work'
      fill_in 'Title', with: 'Lease test'
      check 'I have read and accept the contributor license agreement'
      choose 'Lease'
      select 'Open Access', from: 'Is available for'
      select 'Private', from: 'then restrict it to'
      click_button 'Create Generic work'

      click_link "Edit This Generic Work"
      click_link "Lease Management Page"

      expect(page).to have_content("This work is under lease.")

      fill_in "until", with: future_date.to_s

      click_button "Update Lease"
      expect(page).to have_content(future_date.to_date.to_formatted_s(:long_ordinal))
    end

  end

  describe "managing leases" do
    before do
      # admin privs
      allow_any_instance_of(Ability).to receive(:user_groups).and_return(['admin'])
    end
    it "should show lists of objects under lease" do
      visit '/leases'
      expect(page).to have_content 'Manage Leases'
    end
  end
end
