class ReviewsController < ApplicationController
  load_and_authorize_resource
  def index
    @reviews = [];
     Review.includes({:junior_consultant => :coach}, 
                    {:junior_consultant => 
                        {:reviewing_group => 
                            {:reviewing_group_members => :user}}}, 
                    :feedbacks, 
                    :invitations).all.each do |review|
        if can? :summary, review
          @reviews << review
        end
      end
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      # if @review.old_format
      #   format { "show" }
      # else
      #   format { "show_new" }
      # end
      # format.html { render select_view_for_review_id(params[:id].to_i) }
      format.json { render json: @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.json
  def new
    @review = Review.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(params[:review])

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render json: @review, status: :created, location: @review }
      else
        format.html { render action: "new" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.json
  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      if @review.update_attributes(params[:review])
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  # GET /feedbacks
  # GET /feedbacks.json
  def summary
    @feedbacks = []
    @review.feedbacks.each do |f|
      if can? :read, f
        @feedbacks << f
      end
    end

    respond_to do |format|
      format.html # summary.html.erb
      format.json { render json: @feedbacks }
      format.xlsx
    end
  end

  def send_email
    @review = Review.find params[:id]
    UserMailer.review_creation(@review).deliver
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { head :ok }
    end
  end
end
