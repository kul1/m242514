class DocsController < ApplicationController
  before_action :load_doc, only: [:show, :destroy]

	def index
    @docs = Mindapp::Doc.where(name: 'filename').desc(:created_at).page(params[:page]).per(10)

	end

  def show 

    doc = Mindapp::Doc.find params[:id]
    if doc.cloudinary
      require 'net/http'
      require "uri"
      uri = URI.parse(doc.url)
      data = Net::HTTP.get_response(uri)
      send_data(data.body, :filename=>doc.filename, :type=>doc.content_type, :disposition=>"inline")
    else
      data= read_binary(doc.url)
      send_data(data, :filename=>doc.filename, :type=>doc.content_type, :disposition=>"inline")
    end
  
    
  end

  def edit
    @doc = Doc.find(params[:id])
    @page_title       = 'Member Login'

  end

  def create
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    @doc = Mindapp::Doc.new(
                      filename: $xvars["form_doc"]["filename"],
                      user_id: $xvars["user_id"])
    @doc.save!
  end

  def my
    @docs = Mindapp::Doc.where(user_id: current_ma_user, name: 'filename').desc(:created_at).page(params[:page]).per(10)
    @page_title       = 'Document List'
  end

  def update
    # $xvars["select_doc"] and $xvars["edit_doc"]
    # These are variables.
    # They contain everything that we get their forms select_doc and edit_doc
    doc_id = $xvars["select_doc"] ? $xvars["select_doc"]["title"] : $xvars["p"]["doc_id"]
    @doc = Doc.find(doc_id)
    @doc.update(title: $xvars["edit_doc"]["doc"]["title"],
                    text: $xvars["edit_doc"]["doc"]["text"],
                    keywords: $xvars["edit_doc"]["doc"]["keywords"],
                    body: $xvars["edit_doc"]["doc"]["body"])

  end

  def destroy
    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @doc.user
      @doc.destroy
    end
      redirect_to :action=>'index'
  end

  private

  def load_doc
    @doc = Mindapp::Doc.find(params[:id])
  end
	
end
