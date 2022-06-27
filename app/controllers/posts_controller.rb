class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  def index
    @posts = Post.all
    # @posts.start_time
    # <td class="day wday-1 future current-month">27</td>
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: @post.user_id)
    @user = @post.user
  end
  
  def create
    @post = Post.new(
      content: params[:content],
      user_id: @current_user.id,
      title: params[:title],
      start_time: params[:start_time]
                     )
    # @post[:start_time] = Date.today.strftime('%Y-%m-%d')
    @post.save
    # Post.create(post_parameter)
    # redirect_to root_path
    redirect_to("/posts/index")
  end

  # private

  # def posts_parameter
  #   params.require(:post).permit(:title, :content, :start_time)
  # end

  def create_comment
    @post = Post.find_by(id: params[:id])
    @post.comment = params[:comment]
    @post.save
    redirect_to("/posts/index")
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    @post.save
    redirect_to("/posts/index")
  end

  def destory
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to("/post/.index") 
  end

  def translation
      @post = Post.find_by(id: params[:id])
      @post.translation = @post.content
      @post.save

      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      @driver = Selenium::WebDriver.for :chrome, options: options
      @driver.manage.window.resize_to(1200, 1000)
      @driver.get("https://translate.weblio.jp/")
      @driver.find_element(:xpath, '//*[@id="originalTextArea"]').click
      sleep 0.5
      @driver.find_element(:xpath, '//*[@id="originalTextArea"]').send_keys(@post.translation) 
      @driver.find_element(:xpath, '//*[@id="JEB"]').click

      document = Nokogiri::HTML(@driver.page_source)
      english_grammar1 = document.xpath('//*[@id="transResultMainLn"]/ul/li').text
      english_grammar2 = document.xpath('//*[@id="transResultMainLn"]/ol/li[1]').text
      english_grammar3 = document.xpath('//*[@id="transResultMainLn"]/ul/li/span').text

      unless english_grammar1.empty?
        @post.translation = english_grammar1
      end
      unless english_grammar2.empty?
        @post.translation = english_grammar2
      end
      unless english_grammar3.empty?
        @post.translation = english_grammar3
      end
      @post.save
      @driver.quit
      # @driver.close
      redirect_to("/posts/#{@post.id}")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end