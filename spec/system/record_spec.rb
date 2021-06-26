require 'rails_helper'
RSpec.describe '健康情報管理機能', type: :system do
  let!(:user) {create(:user)}
  let!(:student) {create(:student,user_id: user.id)}
  # let!(:student2) {create(:student2,user_id: user.id)}
  # let!(:student3) {create(:student3,user_id: user.id)}
  let!(:record) {create(:record,student_id: student.id)}
  # let!(:record2) {create(:record2,student_id: student2.id)}
  # let!(:record3) {create(:record3,student_id: student3.id)}

  before do
    visit new_user_session_path
    click_link 'ログイン'
    fill_in 'user[email]',with: 'kawai@kawai.com'
    fill_in 'user[password]',with: 'password'
    click_button 'ログイン'
  end
  describe '新規作成機能' do
    context '健康情報を新規登録した場合' do
      it '登録した健康情報が表示される' do
        click_link '生徒一覧'
        expect(current_path).to have_content "/students"
        click_on '生徒詳細', match: :first
        click_on '健康状態新規登録'
        expect(page).to have_content '健康情報を登録する'
        fill_in 'record[body_temperature]',with: '36.5'
        click_on 'commit'
        # binding.irb
        expect(page).to have_content '健康管理一覧'
        expect(page).to have_content 'むさし'
        expect(page).to have_content '36.5'
        expect(page).to have_content 'なし'
        expect(page).to have_content 'しない'
        expect(page).to have_content '出ない'
        expect(page).to have_content 'だるくない'
        expect(page).to have_content 'いない'
        expect(page).to have_content '欠席'
      end
    end
  end
    context '健康情報登録に失敗した場合' do
      it '画面遷移せずそのまま新規健康情報登録画面にいること' do
        click_link '生徒一覧'
        expect(current_path).to have_content "/students"
        click_on '生徒詳細', match: :first
        click_on '健康状態新規登録'
        expect(page).to have_content '健康情報を登録する'
        click_button 'commit'
        # binding.irb
        expect(page).to have_content '体温を入力してください'
        expect(page).to have_content '健康情報を登録する'
      end
    end
  describe '健康情報編集機能' do
    context '健康情報を編集する場合' do
      it '健康情報が編集される' do
        click_on '生徒一覧'
        expect(current_path).to have_content "/students"
        # binding.irb
        click_on '生徒詳細', match: :first
        click_on 'この生徒の健康管理一覧'
        click_on '詳細', match: :first
        expect(page).to have_content '健康情報詳細画面'
        click_on '編集'
        page.driver.browser.switch_to.alert.accept
        select(value = "あり", from: "record_is_cough")
        select(value = "しない", from: "record_is_sneeze")
        select(value = "出ない", from: "record_is_runny_nose")
        select(value = "だるい", from: "record_is_dull")
        select(value = "いる", from: "record[is_family_illness]")
        select(value = "欠席", from: "record[attendance]")
        click_on 'commit'
        expect(page).to have_content '健康情報を編集しました'
      end
    end
  end
  describe '健康情報削除機能' do
    context '健康情報を削除する場合' do
      it '健康情報が削除できる' do
        # binding.irb
        click_on '生徒一覧'
        expect(current_path).to have_content "/students"
        click_on '生徒詳細', match: :first
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "生徒一覧"
        expect(page).to have_content "生徒情報を削除しました！"
      end
    end
  end
  describe '生徒検索機能' do
    context '生徒名と学年検索でand検索した場合' do
      it '生徒一覧で検索ができる' do
        click_on '生徒一覧'
        # binding.irb
        expect(current_path).to eq "/students"
        expect(page).to have_content '生徒一覧'
        expect(page).to have_content '生徒名 学年'
        fill_in 'q[student_name_cont]',with: 'し'
        select(value = "2年生", from: "q_school_year_eq")
        click_on'commit'
        expect(current_path).to eq "/students"
        expect(page).to have_content 'むさし'
        expect(page).to have_content 'B'
        expect(page).to have_content '1年生'
      end
    end
  end
end
