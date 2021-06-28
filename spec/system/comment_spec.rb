require 'rails_helper'
RSpec.describe '日記管理機能', type: :system do
  let!(:user) {create(:user)}
  let!(:post) {create(:post,user_id: user.id)}
  let!(:post2) {create(:post2)}
  let!(:post3) {create(:post3)}

  before do
    # visit root_path
    visit new_user_session_path
    # binding.irb
    click_link 'ログイン'
    fill_in 'user[email]',with: 'kawai@kawai.com'
    fill_in 'user[password]',with: 'password'
    click_button 'ログイン'
  end

  describe '日記のコメント機能' do
    context '日記コメントでコメントを投稿した場合' do
      it '投稿したコメントが表示される' do
        click_on '日記一覧'
        # binding.irb
        click_on '詳細', match: :first
        expect(page).to have_content "日記詳細画面"
        fill_in'comment[content]', with: 'ありがとうね！'
        attach_file 'comment[image]', 'app/assets/images/5408DC10-1501-4DE7-8440-F75B4E6D76B6_1_105_c.jpeg'
        click_on 'commit'
        expect(page).to have_content "ありがとうね！"
      end
    end
  end
  describe 'コメント編集機能' do
    context '自分のコメントを編集する場合' do
      it 'コメントが編集される' do
        click_on '日記一覧'
        click_on '詳細', match: :first
        expect(page).to have_content "日記詳細画面"
        fill_in'comment[content]', with: 'ありがとうね！'
        attach_file 'comment[image]', 'app/assets/images/5408DC10-1501-4DE7-8440-F75B4E6D76B6_1_105_c.jpeg'
        click_on 'commit'
        click_on 'コメント編集'
        fill_in 'comment[content]',match: :first, with: ''
        fill_in 'comment[content]',match: :first, with: 'ありがとう、まじで！'
        click_on '更新する'
        # binding.irb
        expect(page).to have_content "コメントが編集されました"
      end
    end
  end
  describe 'コメント削除機能' do
    context 'コメントを削除する場合' do
      it 'コメントが削除できる' do
        click_on '日記一覧'
        click_on '詳細', match: :first
        expect(page).to have_content "日記詳細画面"
        fill_in'comment[content]', with: 'ありがとうね！'
        attach_file 'comment[image]', 'app/assets/images/5408DC10-1501-4DE7-8440-F75B4E6D76B6_1_105_c.jpeg'
        click_on 'commit'
        click_on 'コメント削除'
        expect(page).to have_content "コメントが削除されました"
      end
    end
  end
end
