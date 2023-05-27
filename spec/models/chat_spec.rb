# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectComment, "モデルに関するテスト", type: :model do

  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:chat)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "commentが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      chat = build(:chat, message: nil)
      expect(chat).to be_invalid
      expect(chat.errors[:message]).to include("が入力されていません。")
    end
  end

  context "文字数のバリデーションチェック" do
    it '140文字以下であること: 140文字は〇' do
      chat = create(:chat)
      chat.message = Faker::Lorem.characters(number: 140)
      expect(chat.valid?).to eq true
    end
    it "140文字以下であること: 141文字は×" do
      chat = create(:chat)
      chat.message = Faker::Lorem.characters(number: 141)
      expect(chat.valid?).to eq false
    end
    it "intorductionが141文字以上の場合バリデーションチェックされエラーメッセージが返ってきているか" do
      chat = Chat.new(message: Faker::Lorem.characters(number: 141))
      expect(chat).to be_invalid
      expect(chat.errors[:message]).to include("は140文字以下に設定して下さい。")
    end
  end

end