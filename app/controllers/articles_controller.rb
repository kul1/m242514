class ArticlesController < ApplicationController
  before_action :load_article, only: [:show, :destroy]
  before_action :load_comments, only: :show

	def index
    @articles = Article.desc(:created_at).page(params[:page]).per(10)
	end

  def show 
    prepare_meta_tags(title: @article.title,
                      description: @article.text,
                      keywords: @article.keywords)
  end

  def edit
    @article = Article.find(params[:id])
    @page_title       = 'Member Login'

  end

  def create
    @article = Article.new(
                      title: $xvars["form_article"]["title"],
                      text: $xvars["form_article"]["text"],
                      keywords: $xvars["form_article"]["keywords"],
                      body: $xvars["form_article"]["body"],

                      user_id: $xvars["user_id"])
    @article.save!
  end

  def search
    @q = $xvars["search_article"]["title"] || $xvars["search_article"]["text"] || $xvars["search_article"]["body"] || ""
    @title = "ผลการค้นหา #{@q}"
    @backbtn= true
    @cache= true
    if @q.blank?
      redirect_to "/"
    else
      #s= GmaSearch.create :q=>@q, :ip=> request.env["REMOTE_ADDR"]
      @articles = Article.search(@q.downcase, params[:page], PER_PAGE)
    end
  end

  def do_search_a

    # if current_ma_user.ma_secured?
    #   @docs = Article.search_ma_secured(@q.downcase, params[:page], PER_PAGE)
    # else
      @articles = Article.search(@q.downcase, params[:page], PER_PAGE)
    # end
    #@xmains = GmaXmain.find(@docs.map(&:ma_xmain_id)).sort { |a,b| b.id<=>a.id }
    # @xmains = GmaXmain.find @docs.map(&:created_at).sort { |a,b| b<=>a }
  end




  def my
    @articles = if params[:search]
                  #Article.where('title LIKE ?',"%#{params[:search]}%")
                  Article.search(params[:search])

                else
                  Article.all
                end
    @page_title       = 'Member Login'
  end

  def update
    # $xvars["select_article"] and $xvars["edit_article"]
    # These are variables.
    # They contain everything that we get their forms select_article and edit_article
    article_id = $xvars["select_article"] ? $xvars["select_article"]["title"] : $xvars["p"]["article_id"]
    @article = Article.find(article_id)
    @article.update(title: $xvars["edit_article"]["article"]["title"],
                    text: $xvars["edit_article"]["article"]["text"],
                    keywords: $xvars["edit_article"]["article"]["keywords"],
                    body: $xvars["edit_article"]["article"]["body"])

  end

  def destroy
    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @article.user
      @article.destroy
    end
      redirect_to :action=>'index'
  end

  private

  def load_article
    @article = Article.find(params[:id])
  end

  def load_comments
    @comments = @article.comments.find_all
  end

end
