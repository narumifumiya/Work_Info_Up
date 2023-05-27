# frozen_string_literal: true

require 'rails_helper'

describe 'project_comment投稿のテスト' do
  let!(:user) { create(:user) }
  let!(:company) { create(:company) }
  let!(:project) { create(:project, company: company, user: user) }
  let!(:project_comment) { create(:project_comment, project: project, user: user) }
  let!(:favorite) { create(:favorite, project: project, user: user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'いいねのテスト' do
    before  do
      visit company_project_path(company.id, project.id)
    end
    it 'いいねのカウントが表示されるか' do
      expect(page).to have_content project.favorites.count
    end
  end

end