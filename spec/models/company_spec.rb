# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:company)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      company = Company.new(name: '')
      expect(company).to be_invalid
      expect(company.errors[:name]).to include("が入力されていません。")
    end
  end

  context "重複のバリデーションチェック" do
    it "登録済みのnameは登録できない" do
      company1 = create(:company)
      company = build(:company, name: company1.name)
      company.valid?
      expect(company.errors[:name]).to include("は既に使用されています。")
    end
  end

end