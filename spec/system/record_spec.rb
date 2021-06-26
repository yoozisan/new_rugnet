require 'rails_helper'
RSpec.describe '健康情報管理機能', type: :system do
  let!(:user) {create(:user)}
  let!(:student) {create(:student,user_id: user.id)}
  # let!(:student2) {create(:student2,user_id: user.id)}
  # let!(:student3) {create(:student3,user_id: user.id)}
  let!(:record) {create(:record,student_id: student.id)}
  # let!(:record2) {create(:record2,student_id: student.id)}
  # let!(:record3) {create(:record3,student_id: student.id)}

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
describe '健康情報検索機能' do
  context '日付と出欠席で検索した場合' do
    it '健康管理一覧で検索ができる' do
      click_on '生徒一覧'
      # binding.irb
      expect(current_path).to eq "/students"
      click_on '生徒詳細'
      expect(page).to have_content '生徒詳細画面'
      click_on 'この生徒の健康管理一覧'
      expect(page).to have_content '健康管理一覧'
      # binding.irb
      fill_in 'q[record_at_eq]',with: '002021-06-21'
      click_on 'commit'
      expect(page).not_to have_content "2021-06-25"
      expect(page).not_to have_content "2021-06-23"
      expect(page).to have_content "欠席"
      fill_in 'q[record_at_eq]',with: '002021-06-25'
      select(value = "欠席", from: "q[attendance_eq]")
      click_on 'commit'
      expect(page).not_to have_content "2021-06-23"
      expect(page).not_to have_content "2021-06-21"
      expect(page).to have_content "欠席"
    end
  end
end
describe 'その他' do
  context '日付を未来で入力した場合' do
    it 'バリデーションエラーが発生する' do
      click_link '生徒一覧'
      expect(current_path).to have_content "/students"
      click_on '生徒詳細', match: :first
      click_on '健康状態新規登録'
      expect(page).to have_content '健康情報を登録する'
      fill_in 'record[record_at]',with: '002040-06-21'
      fill_in 'record[body_temperature]',with: '36.5'
      click_on 'commit'
      expect(page).to have_content "1件のエラーがあります。"
      expect(page).to have_content "日付は未来を入力できません。"
    end
  end
  context '体温を35.0℃より低く入力した場合' do
    it 'バリデーションエラーが発生する' do
      click_link '生徒一覧'
      expect(current_path).to have_content "/students"
      click_on '生徒詳細', match: :first
      click_on '健康状態新規登録'
      expect(page).to have_content '健康情報を登録する'
      fill_in 'record[record_at]',with: '002021-06-21'
      fill_in 'record[body_temperature]',with: '34.0'
      click_on 'commit'
      expect(page).to have_content "1件のエラーがあります。"
      expect(page).to have_content "体温は35.0℃より高くなければなりません。"
    end
  end
  context '体温を42℃より高く入力した場合' do
    it 'バリデーションエラーが発生する' do
      click_link '生徒一覧'
      expect(current_path).to have_content "/students"
      click_on '生徒詳細', match: :first
      click_on '健康状態新規登録'
      expect(page).to have_content '健康情報を登録する'
      fill_in 'record[record_at]',with: '002021-06-21'
      fill_in 'record[body_temperature]',with: '50.0'
      click_on 'commit'
      expect(page).to have_content "1件のエラーがあります。"
      expect(page).to have_content "体温は42.0℃より低くなければなりません。"
    end
  end
end
end
