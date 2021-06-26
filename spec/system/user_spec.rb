require 'rails_helper'
RSpec.describe 'User関連機能',type: :system do
  let!(:user){create(:user)}
  let!(:user2){create(:user2)}
  let!(:post){create(:post,user_id: user.id)}
  before do
    visit root_path
  end
  describe 'devise関連機能' do
    context '全ての記述が正しい場合' do
      it 'サインアップできる' do
        visit new_user_registration_path
        fill_in "user[name]", with: "かわい"
        attach_file 'user[image]', 'app/assets/images/5408DC10-1501-4DE7-8440-F75B4E6D76B6_1_105_c.jpeg'
        fill_in "user[email]", with: "test@test.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        sleep(0.5)
        click_button 'アカウント登録'
        expect(page).to have_content 'My Profile'
        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end
    context '入力漏れが合った場合' do
      it 'サインアップできない' do
        visit new_user_registration_path
        # find("#sign_up").click
        click_button 'アカウント登録'
        expect(page).to have_content "名前を入力してください"
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "パスワードを入力してください"
      end
    end
    context '全ての記述が正しい場合' do
      it 'ログインできる' do
        visit new_user_session_path
        # find("#log_in").click
        fill_in 'user[email]',with: 'kawai@kawai.com'
        fill_in 'user[password]', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'My Profile'
        expect(page).to have_content 'ログインしました。'
      end
    end
    context 'emailとpasswordが一致しない場合' do
      it 'ログインできない' do
        visit new_user_session_path
        # find("#log_in").click
        fill_in 'user[email]',with: 'kawai@kawai.com'
        fill_in 'user[password]', with: 'ミスパスワード'
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(current_path).to have_content '/users/sign_in'
      end
    end
    describe 'ログイン後' do
      context 'ログアウトした場合' do
        it  'トップページに戻りログイン状態が解除される' do
          visit root_path
          visit new_user_session_path
          # find("#log_in").click
          fill_in 'user[email]',with: 'kawai@kawai.com'
          fill_in 'user[password]', with: 'password'
          click_button 'ログイン'
          expect(page).to have_content 'My Profile'
          expect(page).to have_content 'ログインしました。'
          sleep(0.5)
          click_on'ログアウト'
          expect(page)
        end
      end
    end
    describe 'その他機能' do
      it 'フォロー一覧機能' do
        visit new_user_session_path
        fill_in 'user[email]',with: 'tukahara@tukahara.com'
        fill_in 'user[password]', with: 'password2'
        # binding.irb
        click_button 'ログイン'
        click_on '日記一覧'
        # binding.irb
        click_on '詳細'
        click_on '河合'
        expect(page).to have_content 'My Profile'
        click_on 'commit'
        click_on '1followers'
        expect(page).to have_content '塚原'
        expect(page).to have_content 'Top'
        expect(page).to have_content 'My Profile'
        expect(page).to have_content 'アカウント編集'
        expect(page).to have_content '日記投稿'
        expect(page).to have_content '生徒登録'
      end
      it 'ゲストログイン機能' do
        visit root_path
        # binding.irb
        click_on 'ゲストログイン（閲覧用）'
        expect(page).to have_content '生徒一覧'
        expect(page).to have_content '日記一覧'
        expect(page).to have_content 'My Profile'
      end
      it 'ゲストログイン（管理者）機能' do
        visit root_path
        # binding.irb
        click_on 'ゲストログイン（管理者）'
        expect(page).to have_content '生徒一覧'
        expect(page).to have_content '日記一覧'
        expect(page).to have_content 'My Profile'
        expect(page).to have_content '管理者画面'
      end
      it 'ゲストログイン（コーチ）機能' do
        visit root_path
        # binding.irb
        click_on 'ゲストログイン（コーチ）'
        expect(page).to have_content '生徒一覧'
        expect(page).to have_content '生徒健康情報一覧'
        expect(page).to have_content '日記一覧'
        expect(page).to have_content 'My Profile'
      end
    end
  end
end
