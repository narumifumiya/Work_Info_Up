# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("が入力されていません。")
    end
    it "name_kanaが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      user = build(:user, name_kana: nil)
      expect(user).to be_invalid
      expect(user.errors[:name_kana]).to include("が入力されていません。")
    end
    it "phone_numberが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      user = build(:user, phone_number: nil)
      expect(user).to be_invalid
      expect(user.errors[:phone_number]).to include("が入力されていません。")
    end
    it "emailが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("が入力されていません。")
    end
    it "passwordが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      user = build(:user, password: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("が入力されていません。")
    end
  end
  it "パスワードと確認が一致していないと登録できない" do
    user = build(:user, password_confirmation: "")
    expect(user).to be_invalid
    expect(user.errors[:password_confirmation]).to include("が内容とあっていません。")
  end
  context "重複のバリデーションチェック" do
    it "登録済みのphone_numberは登録できない" do
      user1 = create(:user)
      user = build(:user, phone_number: user1.phone_number)
      user.valid?
      expect(user.errors[:phone_number]).to include("は既に使用されています。")
    end
    it "登録済みのemailアドレスでは登録できない" do
      user1 = create(:user)
      user = build(:user, email: user1.email)
      user.valid?
      expect(user.errors[:email]).to include("は既に使用されています。")
    end
  end

end