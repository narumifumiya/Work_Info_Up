require 'rails_helper'

RSpec.describe Customer, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:customer)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      customer = Customer.new(name: '')
      expect(customer).to be_invalid
      expect(customer.errors[:name]).to include("が入力されていません。")
    end
  end
end