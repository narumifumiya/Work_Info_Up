# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー編集のテスト' do
  let!(:user) { create(:user) }
  let!(:department) { create(:department)}
  let!(:company) { create(:company) }
  let!(:project) { create(:project, company: company, user: user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe '一覧画面のテスト' do
    before do
      visit public_users_path
    end
    context '一覧画面の表示とリンクの確認' do
      it 'user一覧と部署一覧、グループ一覧リンク、新しい順、古い順が表示されているか' do
        expect(page).to have_selector '.user-card'
        expect(page).to have_selector '.list-group'
        expect(page).to have_link "新しい順", href: public_users_path(latest: "true")
        expect(page).to have_link "古い順", href: public_users_path(old: "true")
        expect(page).to have_link "グループ一覧", href: groups_path
      end
      it 'userの写真、名前、役職、部署が表示されているか' do

        visit public_users_path
        User.all.each_with_index do |user|
          expect(page).to have_selector("img[src$='default-image.jpg']")
          expect(page).to have_content user.name
          expect(page).to have_content user.position
          expect(page).to have_content user.department.name
        end
      end
      it '部署一覧で部署名が表示されているか' do
        visit public_users_path
        Department.all.each_with_index do |department|
          expect(page).to have_content department.name
        end
      end
    end
  end

  describe 'user詳細画面のテスト' do
    before  do
      visit public_user_path(user.id)
    end
    context '表示の確認' do
      it 'ユーザー画像、ユーザー名、フリガナ、役職、所属部署、email、電話番号、在籍状態が表示される' do
        expect(page).to have_selector("img[src$='default-image.jpg']")
        expect(page).to have_content user.name
        expect(page).to have_content user.name_kana
        expect(page).to have_content user.position
        expect(page).to have_content user.department.name
        expect(page).to have_content user.email
        expect(page).to have_content user.phone_number
        expect(page).to have_content '在籍中' 
      end
      it 'いいね一覧、編集のリンクがある' do
        expect(page).to have_link "いいねしたプロジェクトを見る", href: public_path(user.id)
        expect(page).to have_link "編集", href: edit_public_user_path(user.id)
      end
      it '担当案件一覧(table)が表示される' do
        expect(page).to have_selector 'table'
        user.projects.each do |project|
          expect(page).to have_link project.name, href: company_project_path(company.id, project.id)
          expect(page).to have_content '営業中' 
          expect(page).to have_content '未着手' 
        end
      end
    end
  end

  describe '編集画面のテスト' do
    before do
     visit edit_public_user_path(user.id)
    end
    context '表示の確認' do
      it '編集前の情報がフォームに表示(セット)されている' do
        expect(page).to have_field 'user[name]', with: user.name
        expect(page).to have_field 'user[name_kana]', with: user.name_kana
        expect(page).to have_field 'user[email]', with: user.email
        expect(page).to have_field 'user[phone_number]', with: user.phone_number
        expect(page).to have_field 'user[department_id]', with: user.department_id
        expect(page).to have_field 'user[profile_image]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '戻るリンクがあるか' do
        expect(page).to have_link "戻る", href: public_user_path(user.id)
      end
    end
    context '更新処理に関するテスト' do
      it '更新に成功しサクセスメッセージが表示されるか' do
        fill_in 'user[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'user[name_kana]', with: Faker::Lorem.characters(number:20)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[phone_number]', with: Faker::Lorem.characters(number:10)
        fill_in 'user[position]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_content 'メンバー情報を変更しました'
      end
      it '投稿に失敗する' do
        fill_in 'user[name]', with: ''
        click_button '登録'
        expect(page).to have_content 'が入力されていません。'
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'user[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'user[name_kana]', with: Faker::Lorem.characters(number:20)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[phone_number]', with: Faker::Lorem.characters(number:10)
        fill_in 'user[position]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_current_path public_user_path(user.id)
      end
    end

  end

end