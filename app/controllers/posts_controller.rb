class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def new
    @post = Post.new
    authorize @post
  end

  def index
    @posts = Post.all.order('created_at desc').page(params[:page])
  end

  def me
    @posts = policy_scope(Post).order('created_at desc').page(params[:page])  unless current_user.reader?
    @posts = nil  if current_user.reader?
    if current_user.reader?
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to posts_path
    elsif @post.nil?
      flash[:notice] = "You have not posts."
      redirect_to posts_path
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    authorize @post
    redirect_to posts_path, alert: "This post doesn't exist." unless @post
  end

  def create
    @post = Post.new(post_params)
    authorize @post
    if @post.save
      redirect_to @post, notice: "Post was created!"
    else
      render :new,  notice: "Error"
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    authorize @post
  end

  def update
    @post = Post.find_by(id: params[:id])
    authorize @post
    if @post.update_attributes!(post_params)
      redirect_to @post, notice: "Post updated"
    else
      redirect_to :edit, notice: "Error updating Post"
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    authorize @post
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully deleted."
  end


  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end
end
