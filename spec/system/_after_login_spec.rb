# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:department) { create(:department) }
  let(:company) { create(:company) }
  let!(:office) { create(:office, company: company) }
  let!(:customer) { create(:customer, company: company) }
  let!(:project) { create(:project, company: company) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'Work Info Upを押すと、トップ画面に遷移する' do
        home_link = 'top'
        click_link home_link
        is_expected.to eq '/'
      end
      it '通知を押すと、通知一覧画面に遷移する' do
        notification_link = find_all('a')[1].text
        notification_link = notification_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link notification_link
        is_expected.to eq '/notifications'
      end
      it '得意先を押すと、得意先一覧画面に遷移する' do
        company_link = find_all('a')[2].text
        company_link = company_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link company_link
        is_expected.to eq '/companies'
      end
      it 'メンバーを押すと、メンバー一覧画面に遷移する' do
        member_link = find_all('a')[3].text
        member_link = member_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link member_link
        is_expected.to eq '/public/users'
      end
      it 'マイページを押すと、マイページ一覧画面に遷移する' do
        mypage_link = find_all('a')[4].text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/public/users/' + user.id.to_s
      end
    end
  end

end