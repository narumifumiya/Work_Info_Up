# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, "モデルに関するテスト", type: :model do

  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:notification)).to be_valid
    end

    context 'project関連の通知' do
      let!(:user) { create(:user) }
      let!(:company) { create(:company) }
      let!(:project) { create(:project, company: company, user: user) }
      let!(:project_comment) { create(:project_comment, project: project, user: user) }

      it 'いいね通知が作成されるか' do
        notification = FactoryBot.create(:notification, visitor_id: user.id, visited_id: user.id, project_id: project.id, action: "favorite")
        expect(notification).to be_valid
      end
      it 'コメント通知が作成されるか' do
        notification = FactoryBot.create(:notification, visitor_id: user.id, visited_id: user.id, project_id: project.id, project_comment_id: project_comment.id, action: "comment")
        expect(notification).to be_valid
      end
    end

    context 'group関連の通知' do
      let!(:user) { create(:user) }
      let!(:group) { create(:group)}
      let!(:chat) { create(:chat, user: user, group: group)}

      it 'グループ参加通知が作成されるか' do
        notification = FactoryBot.create(:notification, visitor_id: user.id, visited_id: user.id, group_id: group.id, action: "join")
        expect(notification).to be_valid
      end
      it 'グループチャット通知が作成されるか' do
        notification = FactoryBot.create(:notification, visitor_id: user.id, visited_id: user.id, group_id: group.id, chat_id: chat.id, action: "chat")
        expect(notification).to be_valid
      end
    end

  end





end