class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  def index
    @posts = Post.all.order(created_at: :desc)
    @q = @posts.ransack(params[:q])
    @posts = @q.result(distinct: true)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:back]
      render :new
    else
      if @post.save
        redirect_to posts_path, notice: "日記を作成しました！"
      else
        render :new
      end
    end
  end

  def edit
  end

  def show
    @comments = @post.comments.includes(:user).all
    @comment = @post.comments.build
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "日記を編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice:"日記を削除しました！"
  end

  def confirm
    @post = current_user.posts.build(post_params)
    render :new if @post.invalid?
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :image, :image_cache)
    end

  def set_post
    @post = Post.find(params[:id])
  end

end
