# frozen_string_literal: true

require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ログインリンクが表示される: 緑色のボタンの表示が「ログイン」である' do
        log_in_link = find_all('a')[3].text
        expect(log_in_link).to match(/ログイン/)
      end
      it '新規登録リンクの内容が正しい' do
        log_in_link = find_all('a')[3].text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it '新規登録リンクが表示される: 青色のボタンの表示が「新規登録」である' do
        sign_up_link = find_all('a')[4].text
        expect(sign_up_link).to match(/新規登録/)
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[4].text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'Work Info Upリンクが表示される: 左上から1番目のリンクが「Work Info Up」である' do
        home_link = find_all('a')[0].text
        expect(home_link).to match(/Work Info Up/)
      end
      it '新規登録リンクが表示される: 左上から2番目のリンクが「新規登録」である' do
        signup_link = find_all('a')[1].text
        expect(signup_link).to match(/新規登録/)
      end
      it 'ログインリンクが表示される: 左上から3番目のリンクが「ログイン」である' do
        login_link = find_all('a')[2].text
        expect(login_link).to match(/ログイン/)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Work Info Upを押すと、トップ画面に遷移する' do
        home_link = 'top'
        click_link home_link
        is_expected.to eq '/'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[1].text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link, match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[2].text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link, match: :first
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Sign up」と表示される' do
        expect(page).to have_content 'Sign up'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'name_kanaフォームが表示される' do
        expect(page).to have_field 'user[name_kana]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'phone_numberフォームが表示される' do
        expect(page).to have_field 'user[phone_number]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'Log in'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[name_kana]', with: Faker::Lorem.characters(number: 20)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[phone_number]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button 'Log in' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button 'Log in'
        expect(current_path).to eq '/public/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「Log in」と表示される' do
        expect(page).to have_content 'Log in'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'Log in'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/public/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Log in'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
    end

    context 'ヘッダーの表示を確認' do
      it 'Work Info Upリンクが表示される: 左上から1番目のリンクが「Work Info Up」である' do
        home_link = find_all('a')[0].text
        expect(home_link).to match(/Work Info Up/)
      end
      it '通知リンクが表示される: 左上から2番目のリンクが「通知」である' do
        notification_link = find_all('a')[1].text
        expect(notification_link).to match(/通知/)
      end
      it '得意先リンクが表示される: 左上から3番目のリンクが「得意先」である' do
        company_link = find_all('a')[2].text
        expect(company_link).to match(/得意先/)
      end
      it 'メンバーリンクが表示される: 左上から4番目のリンクが「メンバー」である' do
        member_link = find_all('a')[3].text
        expect(member_link).to match(/メンバー/)
      end
      it 'マイページが表示される: 左上から5番目のリンクが「マイページ」である' do
        mypage_link = find_all('a')[4].text
        expect(mypage_link).to match(/マイページ/)
      end
      it 'ログアウトリンクが表示される: 左上から6番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[5].text
        expect(logout_link).to match(/ログアウト/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      logout_link = find_all('a')[5].text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてホーム画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end
