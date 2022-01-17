class PostsController < ApplicationController
include Secured
  before_action :authenticate_user!, only: %i[create update]

  rescue_from Exception do |e|
    render json: { error: e.message }, status: 500
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: 404 
  end
  
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: 422
  end

  def index
    @posts = Post.published
    @posts = PostsSearchService.search(@posts, params[:search]) unless params[:search].nil? && params[:search].blank?
    render json: @posts.includes(:user), status: 200
  end

  def show
    @post = Post.find(params[:id])
    if (@post.published? || (Current.user && @post.user_id == Current.user.id))
      render json: @post, status: 200
    elsif @post.archived?
      render json: { error: 'Not Found' }, status: 404
    end
  end

  def create
    @post = Current.user.posts.create!(create_params)
    render json: @post, status: 201
  end

  def update
    @post = Current.user.posts.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: 200
  end

  def create_params
    params.require(:post).permit(:title, :content, :status)
  end

  def update_params
    params.require(:post).permit(:title, :content, :status)
  end
end
