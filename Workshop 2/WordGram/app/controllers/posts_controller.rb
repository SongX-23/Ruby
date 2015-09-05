class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :comment]
  before_action :authenticate_user
  before_action :check_auth, only:[:edit, :destroy, :update]
  
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.reverse
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)  
    @post.user = current_user
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_interests
    @post = Post.tagged_with(current_user.interest_list, any => true).to_a
    render 'index'
  end

  def comment
    comment = Commnet.new(comment_params)
    comment.post = @post
    comment.user = current_user
    if @comment.save
      format.html { redirect_to @post, notice: 'Comment was successfully created.' }
      format.json { render :show, status: :created, location: @post }
    else
      format.html { render :new }
      format.json { render json: @post.errors, status: :unprocessable_entity }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :tag_list, :user_id)
    end
    def comment_params
      params.require(:comment).permit(:content)
    end

    def check_auth
      unless @post.can_edit? current_user
        redirect_to @post
      end
    end
end
