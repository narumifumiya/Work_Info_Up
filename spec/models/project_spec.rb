# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:project)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      project = Project.new(name: '')
      expect(project).to be_invalid
      expect(project.errors[:name]).to include("が入力されていません。")
    end
  end

  context "文字数のバリデーションチェック" do
    it '140文字以下であること: 140文字は〇' do
      project = create(:project)
      project.introduction = Faker::Lorem.characters(number: 140)
      expect(project.valid?).to eq true
    end
    it "140文字以下であること: 141文字は×" do
      project = create(:project)
      project.introduction = Faker::Lorem.characters(number: 141)
      expect(project.valid?).to eq false
    end
    it "intorductionが141文字以上の場合バリデーションチェックされエラーメッセージが返ってきているか" do
      project = Project.new(introduction: Faker::Lorem.characters(number: 141))
      expect(project).to be_invalid
      expect(project.errors[:introduction]).to include("は140文字以下に設定して下さい。")
    end
  end

  context "start_dateとend_dateが逆転しているかチェック" do
    it "逆転している場合はエラーメッセージが返ってきているか" do
      project = Project.new(start_date: '2024-03-31', end_date: '2022-04-01')
      expect(project).to be_invalid
      expect(project.errors[:end_date]).to include("は開始日より前の日付は登録できません。")
    end
  end



end