# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Department, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:department)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      department = Department.new(name: '')
      expect(department).to be_invalid
      expect(department.errors[:name]).to include("が入力されていません。")
    end
  end

  context "重複のバリデーションチェック" do
    it "登録済みのnameは登録できない" do
      department1 = create(:department)
      department = build(:department, name: department1.name)
      department.valid?
      expect(department.errors[:name]).to include("は既に使用されています。")
    end
  end


end