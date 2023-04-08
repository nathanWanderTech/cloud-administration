# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Articles', type: :request do
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
      it 'should return a list of articles' do
        @article = FactoryBot.create(:article)
        click_link 'Articles'
        expect(current_path).to eq(articles_path)

        expect(page).to have_content(@article.title)
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      # Since there's no real invalid version of this test we skip it
    end
  end

  describe 'GET #show' do
    describe 'valid: ' do
      it 'should return an article' do
        @article = FactoryBot.create(:article)
        click_link 'Articles'
        expect(current_path).to eq(articles_path)

        expect(page).to have_content(@article.title)

        click_link 'Show'
        expect(current_path).to eq(article_path(@article))

        expect(page).to have_content(@article.title)
        expect(page).to have_content(@article.content)
        expect(page).to have_content(@article.user.email)
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      it 'should not return an article if one does not exist' do
        visit article_path(99_999)
        expect(current_path).to eq(articles_path)
        expect(page).to have_content("The article you're looking for cannot be found")
        # save_and_open_page
      end
    end
  end

  describe 'GET #new' do
    describe 'valid: ' do
      it 'should create a new article with valid attributes' do
        click_link 'Articles'
        expect(current_path).to eq(articles_path)

        click_link 'New Article'
        expect(current_path).to eq(new_article_path)

        fill_in 'article_title', with: 'New_Article'
        fill_in 'article_content', with: 'New_content_with_a_lot_of_typing'
        select @user.email, from: 'article[user_id]'
        click_button 'Create Article'
        # save_and_open_page
        expect(page).to have_content('Article was successfully created.')
        expect(page).to have_content('New_Article')
        expect(page).to have_content('New_content_with_a_lot_of_typing')
      end
    end

    describe 'invalid: ' do
      it 'should not create a new article with invalid attributes' do
        click_link 'Articles'
        expect(current_path).to eq(articles_path)

        click_link 'New Article'
        expect(current_path).to eq(new_article_path)

        fill_in 'article_title', with: ''
        fill_in 'article_content', with: ''
        select @user.email, from: 'article[user_id]'
        click_button 'Create Article'
        # save_and_open_page
        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Content can't be blank")
      end
    end
  end

  describe 'GET #edit' do
    describe 'valid: ' do
      it 'should update an article with valid attributes' do
        @article = FactoryBot.create(:article)
        click_link 'Articles'
        expect(current_path).to eq(articles_path)

        expect(page).to have_content(@article.title)

        click_link 'Show'
        expect(current_path).to eq(article_path(@article))

        expect(page).to have_content(@article.title)
        expect(page).to have_content(@article.content)
        expect(page).to have_content(@article.user.email)

        @new_user = FactoryBot.create(:user)

        click_link 'Edit'
        expect(current_path).to eq(edit_article_path(@article))

        fill_in 'article_title', with: 'Edited_Article_Title'
        fill_in 'article_content', with: 'New_New_Article_Content'
        select @new_user.email, from: 'article[user_id]'
        click_button 'Update Article'

        expect(page).to have_content('Article was successfully updated.')
        expect(page).to have_content('Edited_Article_Title')
        expect(page).to have_content('New_New_Article_Content')
        expect(page).to have_content(@new_user.email)
        expect(current_path).to eq(article_path(@article))
        # save_and_open_page
      end
    end

    describe 'invalid: ' do
      it 'should not update an article with invalid attributes' do
        @article = FactoryBot.create(:article)
        click_link 'Articles'
        expect(current_path).to eq(articles_path)

        expect(page).to have_content(@article.title)

        click_link 'Show'
        expect(current_path).to eq(article_path(@article))

        expect(page).to have_content(@article.title)
        expect(page).to have_content(@article.content)
        expect(page).to have_content(@article.user.email)

        click_link 'Edit'
        expect(current_path).to eq(edit_article_path(@article))

        fill_in 'article_title', with: ''
        fill_in 'article_content', with: ''
        click_button 'Update Article'

        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Content can't be blank")
        # save_and_open_page
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'valid: ' do
      it 'should destroy an article when destroy is clicked' do
        @article = FactoryBot.create(:article)
        click_link 'Articles'
        expect(current_path).to eq(articles_path)

        expect(page).to have_content(@article.title)
        click_link 'Destroy'

        expect(current_path).to eq(articles_path)
        expect(page).to have_content('Article was successfully destroyed.')
      end
    end
  end
end
