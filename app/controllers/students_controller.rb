class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def index
    @students = Student.all
    @q = @students.ransack(params[:q])
    @students = @q.result(distinct: true)
  end

  def new
    @student = Student.new
  end

  def edit
    redirect_to students_path, notice: "不正操作を記録しました。" unless current_user.id == @student.user.id
  end

  def show
  end

  def update
    if @student.update(student_params)
      redirect_to students_path, notice: "生徒情報を編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @student.destroy
      redirect_to students_path, notice:"生徒情報を削除しました！"
  end

  def create
    @student = current_user.students.build(student_params)
    if params[:back]
      render :new
    else
      if @student.save
        redirect_to students_path, notice: "生徒情報を登録しました！"
      else
        render :new
      end
    end
  end

  def confirm
    @student = current_user.students.build(student_params)
    render :new if @student.invalid?
  end

  private
  def student_params
    params.require(:student).permit(:student_name, :category, :school_year)
  end

  def set_student
    @student = Student.find(params[:id])
  end

end
