# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite, "モデルに関するテスト", type: :model do
  before do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project)
  end

  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:favorite)).to be_valid
    end
  end

end