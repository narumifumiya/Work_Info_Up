# frozen_string_literal: true

require 'rails_helper'

describe 'office投稿のテスト' do
  let!(:user) { create(:user) }
  let(:company) { create(:company) }
  let!(:office) { create(:office, company: company) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe '一覧画面のテスト' do
    before  do
      visit company_offices_path(company)
    end
    context '一覧画面の表示とリンクの確認' do
      it 'officeの一覧表示(tableタグ)と事業所追加ボタン、新しい順と古い順が表示されているか' do
        expect(page).to have_selector 'table'
        expect(page).to have_link "新しい順", href: company_offices_path(company_id: company.id, latest: "true")
        expect(page).to have_link "古い順", href: company_offices_path(company_id: company.id , old: "true")
        expect(page).to have_link "事業所追加", href: new_company_office_path(company.id)
      end
      it 'officeのタイトルと所在地、電話番号を表示し、編集、削除のリンクが表示されているか' do
        (1..5).each do |i|
          Office.create(name:'hoge'+i.to_s,post_code:'post_code'+i.to_s,address:'address'+i.to_s)
        end
        visit company_offices_path(company)
        Office.all.each_with_index do |office|
          expect(page).to have_content office.name
          expect(page).to have_content office.total_address
          expect(page).to have_content office.phone_number
          # 編集リンク
          expect(page).to have_link '編集', href: edit_company_office_path(company,office)
          # 削除リンク
          expect(page).to have_link '削除', href: company_office_path(company,office)
        end
      end
    end
    context 'office削除のテスト' do
      it 'officeの削除' do
        expect{ office.destroy }.to change{ Office.count }.by(-1)
         # ※本来はダイアログのテストまで行うがココではデータが削除されることだけをテスト
      end
    end
  end

  describe '事業所新規作成画面のテスト' do
    before  do
      visit new_company_office_path(company)
    end
    context '表示の確認' do
      it '投稿フォームの確認' do
        expect(page).to have_field 'office[name]'
        expect(page).to have_field 'office[post_code]'
        expect(page).to have_field 'office[address]'
        expect(page).to have_field 'office[phone_number]'
      end
      it '登録ボタンがあるか' do
        expect(page).to have_button '登録'
      end
      it '戻るリンクがあるか' do
        expect(page).to have_link "戻る", href: company_offices_path(company.id)
      end
    end
    context '投稿処理に関するテスト' do
      it '投稿に成功しサクセスメッセージが表示されるか' do
        fill_in 'office[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[post_code]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[address]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[phone_number]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_content '事業所を追加しました'
      end
      it '投稿に失敗する' do
        click_button '登録'
        expect(page).to have_content 'が入力されていません。'
        # expect(current_path).to eq('/companies/#{company.id}/offices')
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'office[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[post_code]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[address]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[phone_number]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_current_path company_offices_path(company)
      end
    end
    context 'リンクの遷移先の確認' do
      it '戻るの遷移先は一覧画面か' do
        back_link = find_all('a')[6]
        back_link.click
        expect(page).to have_current_path company_offices_path(company)
      end
    end
  end
  
  describe '編集画面のテスト' do
    before  do
      visit edit_company_office_path(company,office)
    end
    context '表示の確認' do
      it '編集前の情報がフォームに表示(セット)されている' do
        expect(page).to have_field 'office[name]', with: office.name
        expect(page).to have_field 'office[post_code]', with: office.post_code
        expect(page).to have_field 'office[address]', with: office.address
        expect(page).to have_field 'office[phone_number]', with: office.phone_number
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '戻るリンクがあるか' do
        expect(page).to have_link "戻る", href: company_offices_path(company.id)
      end
    end
    context '更新処理に関するテスト' do
      it '更新に成功しサクセスメッセージが表示されるか' do
        fill_in 'office[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[post_code]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[address]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[phone_number]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_content '事業所情報を更新しました'
      end
      it '投稿に失敗する' do
        fill_in 'office[name]', with: ''
        click_button '登録'
        expect(page).to have_content '事業所名が入力されていません'
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'office[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[post_code]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[address]', with: Faker::Lorem.characters(number:10)
        fill_in 'office[phone_number]', with: Faker::Lorem.characters(number:10)
        click_button '登録'
        expect(page).to have_current_path company_offices_path(company)
      end
    end
  end

end