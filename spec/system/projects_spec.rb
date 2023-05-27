# frozen_string_literal: true

require 'rails_helper'

describe 'project投稿のテスト' do
  let!(:user) { create(:user) }
  let!(:company) { create(:company) }
  let!(:project) { create(:project, company: company, user: user) }
  let!(:project_comment) { create(:project_comment, project: project, user: user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe '一覧画面のテスト' do
    before  do
      visit company_projects_path(company.id)
    end
    context '一覧画面の表示とリンクの確認' do
      it 'projectの一覧表示(tableタグ)とプロジェクト追加ボタン、新しい順と古い順、戻るが表示されているか' do
        expect(page).to have_selector 'table'
        expect(page).to have_link "新しい順", href: company_projects_path(company_id: company.id, latest: "true")
        expect(page).to have_link "古い順", href: company_projects_path(company_id: company.id , old: "true")
        expect(page).to have_link "プロジェクト追加", href: new_company_project_path(company.id)
        expect(page).to have_link "戻る", href: company_path(company.id)
      end
      it 'projectの名前と受注ステータス、の表示が表示されているか、名前は詳細ページのリンクになっているか' do
        # (1..5).each do |i|
          # Project.create(name:'hoge'+i.to_s,start_date:'phone_number'+i.to_s,department:'position'+i.to_s)
          # project.create(:project, company: company, user: user)
          # byebug
          # データが作成されていない
        # end
        visit company_projects_path(company.id)
        Project.all.each_with_index do |project|
          expect(page).to have_link project.name, href: company_project_path(company.id, project.id)
          expect(page).to have_content '営業中'
          expect(page).to have_content '未着手'
        end
      end
    end

  end
  describe '顧客新規作成画面のテスト' do
    before  do
      visit new_company_project_path(company)
    end
    context '表示の確認' do
      it '投稿フォームの確認' do
        expect(page).to have_field 'project[name]'
        expect(page).to have_field 'project[contract_amount]'
        expect(page).to have_field 'project[introduction]'
        expect(page).to have_field 'project[tag_name]'
        # expect(page).to have_field 'project[project_images]'
        expect(page).to have_field 'project[start_date]'
        expect(page).to have_field 'project[end_date]'
        expect(page).to have_field 'project[order_status]'
        expect(page).to have_field 'project[progress_status]'
      end
      it '登録ボタンがあるか' do
        expect(page).to have_button '登録'
      end
      it '戻るリンクがあるか' do
        expect(page).to have_link "戻る", href: company_projects_path(company.id)
      end
    end
    context '投稿処理に関するテスト' do
      it '投稿に成功しサクセスメッセージが表示されるか' do
        fill_in 'project[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'project[start_date]', with: Faker::Date.between(from: '2022-04-01', to: '2023-03-31')
        fill_in 'project[end_date]', with: Faker::Date.between(from: '2023-04-01', to: '2024-03-31')
        fill_in 'project[introduction]', with: Faker::Lorem.characters(number:140)
        fill_in 'project[contract_amount]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_content 'プロジェクトを追加しました'
      end
      it '投稿に失敗する' do
        click_button '登録'
        expect(page).to have_content 'が入力されていません。'
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'project[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'project[start_date]', with: Faker::Date.between(from: '2022-04-01', to: '2023-03-31')
        fill_in 'project[end_date]', with: Faker::Date.between(from: '2023-04-01', to: '2024-03-31')
        fill_in 'project[introduction]', with: Faker::Lorem.characters(number:140)
        fill_in 'project[contract_amount]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_current_path company_project_path(company,Project.last)
      end
    end
    context 'リンクの遷移先の確認' do
      it '戻るの遷移先は一覧画面か' do
        back_link = find_all('a')[6]
        back_link.click
        expect(page).to have_current_path company_projects_path(company)
      end
    end
  end

  describe 'プロジェクト詳細画面のテスト' do
    before  do
      visit company_project_path(company.id, project.id)
    end
    context '表示の確認' do
      it '会社名、顧客の名前、役職、所属部署、email、電話番号の表示されるか' do
        expect(page).to have_content project.name
        expect(page).to have_content project.contract_amount
        expect(page).to have_content project.start_date
        expect(page).to have_content project.end_date
        expect(page).to have_content '営業中'
        expect(page).to have_content '未着手'
        expect(page).to have_selector("img[src$='default-image.jpg']")
      end
      it '編集、一覧へ戻るリンクがあるか' do
        expect(page).to have_link "編集", href: edit_company_project_path(company.id, project.id)
        expect(page).to have_link "一覧へ戻る", href: company_projects_path(company.id)
      end
      it 'コメントエリアとコメントフォームが表示されるか' do
        expect(page).to have_selector '#comments_area'
        expect(page).to have_field 'project_comment[comment]'
      end
    end
  end

  describe '編集画面のテスト' do
    before  do
      visit edit_company_project_path(company.id, project.id)
    end
    context '表示の確認' do
      it '編集前の情報がフォームに表示(セット)されている' do
        expect(page).to have_field 'project[name]', with: project.name
        expect(page).to have_field 'project[contract_amount]', with: project.contract_amount
        expect(page).to have_field 'project[introduction]', with: project.introduction
        # expect(page).to have_field 'project[tag_name]', with: project.tags
        # expect(page).to have_field 'project[project_images]'
        expect(page).to have_field 'project[start_date]', with: project.start_date
        expect(page).to have_field 'project[end_date]', with: project.end_date
        expect(page).to have_field 'project[order_status]', with: project.order_status
        expect(page).to have_field 'project[progress_status]', with: project.progress_status
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '戻るリンクがあるか' do
        expect(page).to have_link "戻る", href: company_project_path(company.id, project.id)
      end
    end
    context '更新処理に関するテスト' do
      it '更新に成功しサクセスメッセージが表示されるか' do
        fill_in 'project[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'project[start_date]', with: Faker::Date.between(from: '2022-04-01', to: '2023-03-31')
        fill_in 'project[end_date]', with: Faker::Date.between(from: '2023-04-01', to: '2024-03-31')
        fill_in 'project[introduction]', with: Faker::Lorem.characters(number:140)
        fill_in 'project[contract_amount]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_content 'プロジェクト情報を更新しました'
      end
      it '投稿に失敗する' do
        fill_in 'project[name]', with: ''
        click_button '登録'
        expect(page).to have_content 'が入力されていません。'
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'project[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'project[start_date]', with: Faker::Date.between(from: '2022-04-01', to: '2023-03-31')
        fill_in 'project[end_date]', with: Faker::Date.between(from: '2023-04-01', to: '2024-03-31')
        fill_in 'project[introduction]', with: Faker::Lorem.characters(number:140)
        fill_in 'project[contract_amount]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_current_path company_project_path(company.id, project.id)
      end
    end
  end


end