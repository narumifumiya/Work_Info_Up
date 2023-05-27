# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, "モデルに関するテスト", type: :model do
  before do
    user = FactoryBot.create(:user)
  end

  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:group)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      group = build(:group, name: nil)
      expect(group).to be_invalid
      expect(group.errors[:name]).to include("が入力されていません。")
    end
  end

  context "文字数のバリデーションチェック" do
    it '140文字以下であること: 140文字は〇' do
      group = create(:group)
      group.introduction = Faker::Lorem.characters(number: 140)
      expect(group.valid?).to eq true
    end
    it "140文字以下であること: 141文字は×" do
      group = create(:group)
      group.introduction = Faker::Lorem.characters(number: 141)
      expect(group.valid?).to eq false
    end
    it "intorductionが141文字以上の場合バリデーションチェックされエラーメッセージが返ってきているか" do
      group = Group.new(introduction: Faker::Lorem.characters(number: 141))
      expect(group).to be_invalid
      expect(group.errors[:introduction]).to include("は140文字以下に設定して下さい。")
    end
  end

end