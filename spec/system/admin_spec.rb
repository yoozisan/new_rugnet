require 'rails_helper'
RSpec.describe 'Admin', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }

  describe '管理者機能' do
    context '管理者の場合,' do
      it '管理者ページにアクセスできる' do
        visit root_path
        # binding.irb
        click_on "ログイン"
        fill_in 'user[email]',with: 'kawai@kawai.com'
        fill_in 'user[password]', with: 'password'
        sleep(0.5)
        click_button 'commit'
        expect(page).to have_content 'My Profile'
        expect(page).to have_content 'ログインしました。'
        expect(page).to have_content '管理者画面'
        click_on '管理者画面'
        expect(current_path).to eq rails_admin_path
      end
    end
    context '管理者でない場合,' do
      it '管理者ページにはアクセスできない' do
        visit root_path
        click_on "ログイン"
        fill_in 'user[email]',with: 'tukahara@tukahara.com'
        fill_in 'user[password]', with: 'password2'
        click_button 'commit'
        # binding.irb
        expect(page).to have_content 'My Profile'
        expect(page).to have_content 'ログインしました。'
        expect(page).not_to have_content '管理者画面'
      end
    end
    context 'ログイン画面の管理者ゲストユーザーボタンから' do
      it '管理者ページに遷移できる' do
        visit root_path
        click_link 'ゲストログイン（管理者）'
        expect(page).to have_content 'ゲスト管理者としてログインしました。'
        click_on '管理者画面'
        expect(current_path).to eq rails_admin_path
      end
    end
  end
end
