require 'rails_helper'
describe 'postモデル機能', type: :model do
  let!(:user) {create(:user)}
  let!(:post) {create(:post, user_id: user.id)}

  describe 'バリデーションテスト' do
    context 'タイトルの入力が正しい場合' do
      it '新規作成ができる' do
        expect(post).to be_valid
      end
    end
    context 'タイトルが空の場合' do
      it 'バリデーションエラーとなる' do
        post.title = nil
        expect(post).to be_invalid
      end
    end
    context 'タイトルが20文字以上の場合' do
      it 'バリデーションエラーとなる' do
        post.title = 'a'*21
        expect(post).to be_invalid
      end
    end
    context 'コンテントの入力が正しい場合' do
      it '新規作成できる' do
        expect(post).to be_valid
      end
    end
    context 'コンテントが空の場合' do
      it 'バリデーションエラーとなる' do
        post.content= nil
        expect(post).to be_invalid
      end
    end
    context 'コンテントが255文字以上の場合' do
      it 'バリデーションエラーとなる' do
        post.content = 'a'*256
        expect(post).to be_invalid
      end
    end
  end
end
