# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before(:each) do
    @user = FactoryBot.create(:user) # Create the user

    # Set up the basic premise of the test by making sure that you have to log in
    visit root_path
    expect(current_path).to eq(new_user_session_path)
    expect(current_path).to_not eq(root_path)

    # Within the form #new_user do the following
    # The reason I put this within a within block is so if there are 2 form fields
    # on the page called Email it will fill in only this one
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end

    # Since we've logged in we should check if the application redirected us to the right path
    expect(current_path).to eq(root_path)
    expect(current_path).to_not eq(new_user_session_path)
    expect(page).to have_content('Signed in successfully.')
  end

  describe 'GET #index' do
    describe 'valid: ' do
      it 'should return a list of users' do
        click_link 'Users'
        expect(current_path).to eq(users_path)

        expect(page).to have_content(@user.email)
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      # Since there's no real invalid version of this test we skip it
    end
  end

  describe 'GET #show' do
    describe 'valid: ' do
      it 'should return a user' do
        click_link 'Users'
        expect(current_path).to eq(users_path)

        expect(page).to have_content(@user.email)

        click_link "user_show_#{@user.id}"
        expect(page).to have_content(@user.email)
        expect(page).to have_content(@user.current_sign_in_ip)
        expect(page).to have_content(@user.last_sign_in_ip)
        expect(page).to have_content(@user.current_sign_in_at)
        expect(page).to have_content(@user.last_sign_in_at)
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      it 'should not return a user if one does not exist' do
        visit user_path(99_999)
        expect(current_path).to eq(users_path)
        expect(page).to have_content("The user you're looking for cannot be found")
        # save_and_open_page
      end
    end
  end

  describe 'GET #new' do
    describe 'valid: ' do
      # Devise handles this so we skip
    end

    describe 'invalid: ' do
      # Devise handles this so we skip
    end
  end

  describe 'GET #edit' do
    describe 'valid: ' do
      # Devise handles this so we skip
    end

    describe 'invalid: ' do
      # Devise handles this so we skip
    end
  end

  describe 'DELETE #destroy' do
    describe 'valid: ' do
      # Devise handles this so we skip
    end
  end
end
