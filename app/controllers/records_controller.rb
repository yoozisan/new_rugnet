class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  before_action :set_student, only: %i(index edit new create confirm)

  def index
    # binding.irb
    # @records = Record.all
    student = Student.find(params[:student_id])
    @records = student.records
    # @records = @records.where(student_id: student.id)
    # binding.irb
    @q = @records.ransack(params[:q])
    @records = @q.result(distinct: true)
  end

  # def student_health
  #   @records = Record.all
  #   @q = Record.ransack(params[:q])
  #   @records = @q.result(distinct: true)
  # end

  def new
    @record = Record.new
  end

  def edit
    redirect_to student_records_path, notice: "不正操作を記録しました。" unless current_user.id == @record.student.user.id
  end

  def show
  end

  def update
    if @record.update(record_params)
      redirect_to student_records_path, notice: "健康情報を編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @record.destroy
    redirect_to student_records_path, notice:"健康情報を削除しました！"
  end

  def create
    @record = @student.records.build(record_params)
    # @record = @student.records.build(record_params)
    # @student = Student.find_by(id: params[:student_id])
    # @student = current_user.students.records.build(record_params)
    # @record = Record.new(record_params)
    if params[:back]
      render :new
    else
      if @record.save
        redirect_to student_records_path, notice: "健康情報を登録しました！"
      else
        render :new
      end
    end
  end

  def confirm
    @record = @student.records.build(record_params)
    # @record = @student.records.build(record_params)
    # @student = Student.find(id: student_id)
    # @student = current_user.students.records.build(record_params)
    # @record = Record.new(record_params)
    render :new if @record.invalid?
  end

  private
  def record_params
    params.require(:record).permit(:record_at, :body_temperature, :is_cough, :is_sneeze, :is_runny_nose, :is_dull, :is_family_illness, :attendance, :student_id)
  end

  def set_record
    @record = Record.find(params[:id])
  end

  def set_student
    @student = Student.find(params[:student_id])
  end
end
