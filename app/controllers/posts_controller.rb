class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :result]

  def search
    if (words = params[:search_query]).present?
      # check blank hankaku or zenkaku
      # if words =~ /^(.+?)\p{blank}+(.+)$/

      @posts = Post.search{
        fulltext words
      }.results.sort_by{|post| post.created_at}

      search = Post.search do
        fulltext words, :highlight => true
      end

      @posts = search.results.sort_by{|post| post.created_at}

      @results = Hash.new
      search.hits.each do |hit|
        hit.highlights(:content).each do |highlight|
          id = hit.primary_key.to_s.to_sym
          fr = highlight.format { |word| "<hit>#{word}" }
          @results.merge!(id => ["content",fr])
        end
      end

      render 'index'
    end
  end

  def result
    @posts = @post.around(4)
    @current_id = @post.id
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :user_id, :post_id)
    end
end
