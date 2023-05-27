# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectComment, "モデルに関するテスト", type: :model do
  before do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project)
  end
    # @comment = FactoryBot.build(:comment, user_id: user.id, food_id: food.id)

  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:project_comment)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "commentが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      project_comment = build(:project_comment, comment: nil)
      expect(project_comment).to be_invalid
      expect(project_comment.errors[:comment]).to include("が入力されていません。")
    end
  end

  context "文字数のバリデーションチェック" do
    it '140文字以下であること: 140文字は〇' do
      project_comment = create(:project_comment)
      project_comment.comment = Faker::Lorem.characters(number: 140)
      expect(project_comment.valid?).to eq true
    end
    it "140文字以下であること: 141文字は×" do
      project_comment = create(:project_comment)
      project_comment.comment = Faker::Lorem.characters(number: 141)
      expect(project_comment.valid?).to eq false
    end
    it "intorductionが141文字以上の場合バリデーションチェックされエラーメッセージが返ってきているか" do
      project_comment = ProjectComment.new(comment: Faker::Lorem.characters(number: 141))
      expect(project_comment).to be_invalid
      expect(project_comment.errors[:comment]).to include("は140文字以下に設定して下さい。")
    end
  end
end
