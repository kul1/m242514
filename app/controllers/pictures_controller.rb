class PicturesController < ApplicationController
  before_action :load_picture, only: [:show, :destroy]

  def index
    @pictures = Picture.desc(:created_at).page(params[:page]).per(10)
  end
  def upload
  end
  def show
    prepare_meta_tags(title: @picture.title,
                      description: @picture.text,
                      keywords: @picture.keywords)
  end

  def edit
    @picture = Picture.find(params[:id])
    @page_title       = 'Member Login'

  end

  def create
    @picture = Picture.new(
        title: $xvars["form_picture"]["title"],
        text: $xvars["form_picture"]["text"],
        keywords: $xvars["form_picture"]["keywords"],
        body: $xvars["form_picture"]["body"],

        user_id: $xvars["user_id"])
    @picture.save!
  end

  def my
    @pictures = Picture.where(user_id: current_ma_user).desc(:created_at).page(params[:page]).per(10)
    @page_title       = 'Member Login'
  end

  def update
    # $xvars["select_picture"] and $xvars["edit_picture"]
    # These are variables.
    # They contain everything that we get their forms select_picture and edit_picture
    picture_id = $xvars["select_picture"] ? $xvars["select_picture"]["title"] : $xvars["p"]["picture_id"]
    @picture = Picture.find(picture_id)
    @picture.update(title: $xvars["edit_picture"]["picture"]["title"],
                    text: $xvars["edit_picture"]["picture"]["text"],
                    keywords: $xvars["edit_picture"]["picture"]["keywords"],
                    body: $xvars["edit_picture"]["picture"]["body"])

  end

  def destroy
    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @picture.user
      @picture.destroy
    end
    redirect_to :action=>'index'
  end

  private

  def load_picture
    @picture = Picture.find(params[:id])
  end

  def load_comments
    @comments = @picture.comments.find_all
  end

  params.permit(:picture)

end
