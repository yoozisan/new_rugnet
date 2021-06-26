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

  describe '新規作成機能' do
    context '日記を新規作成した場合' do
      it '作成した日記が表示される' do
        click_link '日記投稿'
        expect(current_path).to have_content '/posts/new'
        fill_in 'post[title]',with: '確認用タイトル'
        fill_in 'post[content]', with: '確認用コンテント'
        attach_file 'post[image]', 'app/assets/images/5408DC10-1501-4DE7-8440-F75B4E6D76B6_1_105_c.jpeg'
        sleep(0.5)
        click_button '登録する'
        expect(current_path).to have_content '/posts/confirm'
        click_button '登録する'
        expect(current_path).to have_content '/posts'
        expect(page).to have_content '確認用タイトル'
        expect(page).to have_content '確認用コンテント'
        expect(page).to have_selector "img[src$='5408DC10-1501-4DE7-8440-F75B4E6D76B6_1_105_c.jpeg']"
        sleep(0.5)
      end
    end
    context '日記作成に失敗した場合' do
      it '画面遷移せずそのまま新規投稿画面にいること' do
        click_link '日記投稿'
        expect(current_path).to have_content '/posts/new'
        click_button '登録する'
        expect(current_path).to have_content '/posts'
      end
    end
  end
  describe '日記編集機能' do
    context '自分の日記を編集する場合' do
      it '日記が編集される' do
        # binding.irb
        click_on 'タイトル:今日は誕生日'
        click_on '編集'
        page.driver.browser.switch_to.alert.accept
        # binding.irb
        expect(page).to have_content '日記を編集する'
        fill_in "post[content]", with: 'やっぱりね'
        fill_in "post[title]", with: '日記を編集しました！'
        click_button '更新する'
        expect(page).to have_content "日記一覧"
        expect(page).to have_content "日記を編集しました！"
        sleep(0.5)
      end
    end
  end
  describe '日記削除機能' do
    context '日記を削除する場合' do
      it '日記が削除できる' do
        click_on 'タイトル:今日は誕生日'
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "日記一覧"
        expect(page).to have_content "日記を削除しました！"
      end
    end
  end
  describe '日記検索機能' do
    context '日記検索でタイトル・内容にて検索した場合' do
      it '日記一覧であいまい検索ができる' do
        click_on '日記一覧'
        # binding.irb
        expect(current_path).to eq "/posts"
        expect(page).to have_content '日記一覧'
        expect(page).to have_content 'タイトルor内容検索'
        # binding.irb
        expect(page).to have_content "アジリティの練習が楽しそうだった。"
        expect(page).to have_content "沢山の人に祝ってもらった。"
        expect(page).to have_content "子供からのプレゼントに感動。"
        fill_in'q[title_or_content_cont]', with: '感動'
        click_on 'commit'
        expect(page).to have_content "子供からのプレゼントに感動。"
        expect(page).not_to have_content "沢山の人に祝ってもらった。"
        expect(page).not_to have_content "アジリティの練習が楽しそうだった。"
      end
    end
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
