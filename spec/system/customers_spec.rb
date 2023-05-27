# frozen_string_literal: true

require 'rails_helper'

describe 'customer投稿のテスト' do
  let!(:user) { create(:user) }
  let(:company) { create(:company) }
  let!(:customer) { create(:customer, company: company) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe '一覧画面のテスト' do
    before  do
      visit company_customers_path(company)
    end
    context '一覧画面の表示とリンクの確認' do
      it 'customerの一覧表示(tableタグ)と顧客追加ボタン、新しい順と古い順、戻るが表示されているか' do
        expect(page).to have_selector 'table'
        expect(page).to have_link "新しい順", href: company_customers_path(company_id: company.id, latest: "true")
        expect(page).to have_link "古い順", href: company_customers_path(company_id: company.id , old: "true")
        expect(page).to have_link "顧客追加", href: new_company_customer_path(company.id)
        expect(page).to have_link "戻る", href: company_path(company.id)
      end
      it 'customerの名前と役職、所属部署の表示が表示されているか、名前は詳細ページのリンクになっているか' do
        (1..5).each do |i|
          Customer.create(name:'hoge'+i.to_s,email:'phone_number'+i.to_s,department:'position'+i.to_s)
        end
        visit company_customers_path(company)
        Customer.all.each_with_index do |customer|
          expect(page).to have_link customer.name, href: company_customer_path(company.id, customer.id)
          expect(page).to have_content customer.position
          expect(page).to have_content customer.department
        end
      end
    end
  end

  describe '顧客新規作成画面のテスト' do
    before  do
      visit new_company_customer_path(company)
    end
    context '表示の確認' do
      it '投稿フォームの確認' do
        expect(page).to have_field 'customer[name]'
        expect(page).to have_field 'customer[email]'
        expect(page).to have_field 'customer[phone_number]'
        expect(page).to have_field 'customer[department]'
        expect(page).to have_field 'customer[position]'
        expect(page).to have_field 'customer[customer_image]'
      end
      it '登録ボタンがあるか' do
        expect(page).to have_button '登録'
      end
      it '戻るリンクがあるか' do
        expect(page).to have_link "戻る", href: company_customers_path(company.id)
      end
    end
    context '投稿処理に関するテスト' do
      it '投稿に成功しサクセスメッセージが表示されるか' do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[phone_number]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[department]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[position]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_content '顧客を追加しました'
      end
      it '投稿に失敗する' do
        click_button '登録'
        expect(page).to have_content 'が入力されていません。'
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[phone_number]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[department]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[position]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_current_path company_customer_path(company,Customer.last)
      end
    end
    context 'リンクの遷移先の確認' do
      it '戻るの遷移先は一覧画面か' do
        back_link = find_all('a')[6]
        back_link.click
        expect(page).to have_current_path company_customers_path(company)
      end
    end
  end

  describe '顧客詳細画面のテスト' do
    before  do
      visit company_customer_path(company.id, customer.id)
    end
    context '表示の確認' do
      it '顧客画像、会社名、顧客の名前、役職、所属部署、email、電話番号の表示されるか' do
        expect(page).to have_content company.name
        expect(page).to have_content customer.name
        expect(page).to have_content customer.email
        expect(page).to have_content customer.phone_number
        expect(page).to have_content customer.department
        expect(page).to have_content customer.position
        expect(page).to have_selector("img[src$='default-image.jpg']")
      end
      it '編集、削除、一覧へ戻るリンクがあるか' do
        expect(page).to have_link "編集", href: edit_company_customer_path(company.id, customer.id)
        expect(page).to have_link "削除", href: company_customer_path(company.id, customer.id)
        expect(page).to have_link "一覧へ戻る", href: company_customers_path(company.id)
      end
    end
    context 'customer削除のテスト' do
      it 'customerの削除' do
        expect{ customer.destroy }.to change{ Customer.count }.by(-1)
         # ※本来はダイアログのテストまで行うがココではデータが削除されることだけをテスト
      end
    end
  end

  describe '編集画面のテスト' do
    before  do
      visit edit_company_customer_path(company.id, customer.id)
    end
    context '表示の確認' do
      it '編集前の情報がフォームに表示(セット)されている' do
        expect(page).to have_field 'customer[name]', with: customer.name
        expect(page).to have_field 'customer[email]', with: customer.email
        expect(page).to have_field 'customer[phone_number]', with: customer.phone_number
        expect(page).to have_field 'customer[department]', with: customer.department
        expect(page).to have_field 'customer[position]', with: customer.position
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '戻るリンクがあるか' do
        expect(page).to have_link "戻る", href: company_customer_path(company.id, customer.id)
      end
    end
    context '更新処理に関するテスト' do
      it '更新に成功しサクセスメッセージが表示されるか' do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[phone_number]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[department]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[position]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_content '顧客情報を更新しました'
      end
      it '投稿に失敗する' do
        fill_in 'customer[name]', with: ''
        click_button '登録'
        expect(page).to have_content 'が入力されていません。'
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[phone_number]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[department]', with: Faker::Lorem.characters(number:10)
        fill_in 'customer[position]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_current_path company_customer_path(company.id, customer.id)
      end
    end
  end

end