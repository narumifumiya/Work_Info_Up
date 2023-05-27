# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite, "モデルに関するテスト", type: :model do

  describe '実際に保存してみる' do
    let!(:user) { create(:user) }
    let!(:company) { create(:company) }
    let!(:project) { create(:project, company: company, user: user) }
    it "有効な投稿内容の場合は保存されるか" do
      favorite = FactoryBot.create(:favorite, user_id: user.id, project_id: project.id)
      expect(favorite).to be_valid
    end
  end

end