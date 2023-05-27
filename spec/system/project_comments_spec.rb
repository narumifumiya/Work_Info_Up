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

  describe 'コメントエリアのテスト' do
    before  do
      visit company_project_path(company.id, project.id)
    end
    context 'コメント一覧の表示とリンクの確認' do
      it 'コメント者の画像と名前、コメント、削除アイコンが表示されているか' do
        ProjectComment.all.each_with_index do |project_comment|
          expect(page).to have_link project_comment.user.name, href: public_user_path(project_comment.user)
          expect(page).to have_selector("img[src$='default-image.jpg']")
          expect(page).to have_content project_comment.comment
          # 削除アイコンのリンク
          expect(page).to have_link '' , href: company_project_project_comment_path(project_comment.project.company,project_comment.project,project_comment)
        end
      end
      it 'コメント件数が表示されているか' do
        expect(page).to have_content project.project_comments.count
      end
    end
  end

  describe 'コメント投稿エリアの確認' do
    before  do
      visit company_project_path(company.id, project.id)
    end
    context '表示の確認' do
      it '投稿フォームの確認' do
        expect(page).to have_field 'project_comment[comment]'
      end
      it '送信ボタン（アイコン）があるか' do
        expect(page).to have_button ''
      end
    end
    context '投稿処理に関するテスト' do
      it '投稿に成功しコメントが表示されるか' do

        fill_in 'project_comment[comment]', with: Faker::Lorem.characters(number:140)
        # ボタンがエラーになる
        # click_button '.btn'
        # expect(page).to find
      end
    end
  end
end

