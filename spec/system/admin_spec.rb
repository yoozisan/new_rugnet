require 'rails_helper'
RSpec.describe 'Admin', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:post2) { FactoryBot.create(:post2, user_id:user2.id) }
  let!(:student) {create(:student,user_id: user.id)}
  let!(:record) {create(:record,student_id: student.id)}
  let!(:comment) { FactoryBot.create(:comment, post_id:post2.id, user_id:user.id) }

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
  describe '管理者機能' do
    before do
      visit root_path
      click_on 'ゲストログイン（管理者）'
      click_on '管理者画面'
    end

    context '管理者の場合,' do
      it '管理者ページにアクセスできて日記の削除ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('日記').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('削除').click
        click_on('実行する')
        expect(page).to have_content '日記の削除に成功しました'
      end
    end
    context '管理者の場合,' do
      it '管理者ページにアクセスできて日記の編集ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('日記').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('編集').click
        find_by_id('post_content').set "編集させていただきやした！"
        click_button '保存'
        expect(page).to have_content '日記の更新に成功しました'
      end
    end
    context '管理者の場合,' do
      it '管理者ページにアクセスできてコメントの編集ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('コメント').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('編集').click
        find_by_id('comment_content').set "やったね！"
        click_button '保存'
        expect(page).to have_content 'コメントの更新に成功しました'
      end
    end
    context '管理者の場合,' do
      it '管理者ページにアクセスできてコメントの削除ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('コメント').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('削除').click
        click_on('実行する')
        expect(page).to have_content 'コメントの削除に成功しました'
      end
    end


    context '管理者の場合,' do
      it '管理者ページにアクセスできてユーザーの編集ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('ユーザー').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('編集').click
        # binding.irb
        find_by_id('user_name').set "トリビソンノ"
        click_button '保存'
        expect(page).to have_content 'ユーザーの更新に成功しました'
      end
    end
    context '管理者の場合,' do
      it '管理者ページにアクセスできてユーザーの削除ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('ユーザー').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('削除').click
        # binding.irb
        click_on('実行する')
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      end
    end
    context '管理者の場合,' do
      it '管理者ページにアクセスできて生徒の編集ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('生徒').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('編集').click
        # binding.irb
        find_by_id('student_student_name').set "世界の室伏"
        click_button '保存'
        expect(page).to have_content '生徒の更新に成功しました'
      end
    end
    context '管理者の場合,' do
      it '管理者ページにアクセスできて生徒の削除ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('生徒').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('削除').click
        # binding.irb
        click_on('実行する')
        expect(page).to have_content '生徒の削除に成功しました'
      end
    end
    context '管理者の場合,' do
      it '管理者ページにアクセスできて健康情報の編集ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('健康情報').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('編集').click
        find_by_id('record_record_at').set "2021年06月01日"
        find_by_id('record_body_temperature').set "38.0"
        click_button '保存'
        expect(page).to have_content '健康情報の更新に成功しました'
      end
    end
    context '管理者の場合,' do
      it '管理者ページにアクセスできて健康情報の削除ができる。' do
        expect(current_path).to eq rails_admin_path
        find('.nav-pills').find_link('健康情報').click
        find_by_id('list').find_by_id("bulk_form").find(".table-condensed").first('tr:nth-child(1) td:nth-child(9)').find(".list-inline").find_link('削除').click
        # binding.irb
        click_on('実行する')
        expect(page).to have_content '健康情報の削除に成功しました'
      end
    end
  end
end
