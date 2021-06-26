require 'rails_helper'
RSpec.describe Comment, type: :model do
  describe 'commentバリデーション機能' do
    context 'コメントが空の場合' do
      it 'バリデーションに引っ掛かる' do
        user2 = create(:user2)
        post3 = create(:post3)
        comment = Comment.new(content: nil, user_id: user2.id, post_id: post3.id)
        expect(comment).to be_invalid
      end
    end
  end
  describe 'comment文字数制限' do
    context 'commentが101文字以上の場合' do
      it 'バリデーションに引っ掛かる' do
        user2 = create(:user2)
        post3 = create(:post3)
        comment = Comment.new(content: 'a'*101, user_id: user2.id, post_id: post3.id)
        expect(comment).to be_invalid
      end
    end
  end
end
