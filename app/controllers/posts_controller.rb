class PostsController < ApplicationController

  rescue_from Exception do |e|
    render json: { error: e.message }, status: 500
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: 422
  end

  def index
    @posts = Post.published
    @posts = PostsSearchService.search(@posts, params[:search]) if !params[:search].nil? && params[:search].present?
    render json: @posts, status: 200
  end

  def show
    @post = Post.find(params[:id])
    render json: @post, status: 200
  end

  def create
    @post = Post.create!(create_params)
    render json: @post, status: 201
  end

  def update
    @post = Post.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: 200
  end

  def create_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
end