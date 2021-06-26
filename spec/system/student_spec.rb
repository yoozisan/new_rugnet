require 'rails_helper'
RSpec.describe '生徒管理機能', type: :system do
  let!(:user) {create(:user)}
  let!(:student) {create(:student,user_id: user.id)}
  let!(:student2) {create(:student2)}
  let!(:student3) {create(:student3)}

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
    context '生徒を新規登録した場合' do
      it '登録した生徒が表示される' do
        click_link '生徒登録'
        # binding.irb
        expect(current_path).to have_content "/students/new"
        fill_in 'student[student_name]',with: 'ケイン・コスギ'
        select(value = "A", from: "student_category")
        # find("#student_category").find("option[value='B']").select_option
        select(value = "2年生", from: "student_school_year")
        click_on 'commit'
        expect(current_path).to have_content "/students/confirm"
        click_button 'commit'
        expect(page).to have_content '生徒一覧'
        expect(page).to have_content 'ケイン・コスギ'
      end
    end
    context '生徒登録に失敗した場合' do
      it '画面遷移せずそのまま新規生徒登録画面にいること' do
        click_link '生徒登録'
        expect(current_path).to have_content "/students/new"
        click_button 'commit'
        expect(current_path).to have_content "/students/confirm"
      end
    end
  end
  describe '生徒編集機能' do
    context '自分の生徒を編集する場合' do
      it '生徒が編集される' do
        click_on '生徒一覧'
        expect(current_path).to have_content "/students"
        # binding.irb
        select(value = "2年生", from: "q[school_year_eq]")
        click_on 'commit'
        click_on '生徒詳細', match: :first
        sleep(0.5)
        # binding.irb
        click_on '編集'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '生徒情報を編集する'
        fill_in "student[student_name]", with: 'シェイン・コスギ'
        select(value = "D", from: "student_category")
        select(value = "幼児", from: "student_school_year")
        click_on 'commit'
        expect(page).to have_content '生徒一覧'
        expect(page).to have_content 'シェイン・コスギ'
        expect(page).to have_content '生徒情報を編集しました！'
      end
    end
  end
  describe '生徒削除機能' do
    context '生徒を削除する場合' do
      it '生徒が削除できる' do
        click_on '生徒一覧'
        expect(current_path).to have_content "/students"
        click_on '生徒詳細', match: :first
        # sleep(2.0)
        # binding.irb
        click_on '削除'
        sleep(2.0)
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
        expect(current_path).to eq "/students"
        expect(page).to have_content '生徒一覧'
        expect(page).to have_content '生徒名 学年'
        fill_in 'q[student_name_cont]',with: 'し'
        select(value = "2年生", from: "q_school_year_eq")
        click_on'commit'
        expect(current_path).to eq "/students"
        sleep(2.0)
        expect(page).to have_content 'むさし'
        expect(page).to have_content 'B'
        expect(page).to have_content '1年生'
      end
    end
  end
end
