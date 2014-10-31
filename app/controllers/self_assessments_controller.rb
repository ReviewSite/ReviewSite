class SelfAssessmentsController < ApplicationController
  load_resource :review
  load_and_authorize_resource :through => :review

  def new
    @self_assessment.associate_consultant = @review.associate_consultant

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @self_assessment }
    end
  end

  def edit
  end

  def create
    @self_assessment.associate_consultant = @review.associate_consultant

    respond_to do |format|
      if @self_assessment.save
        flash[:success] = "Self Assessment was successfully created."
        format.html { redirect_to summary_review_path(@review) }
        format.json { render json: @self_assessment, status: :created, location: summary_review_path(@review) }
      else
        format.html { render action: "new" }
        format.json { render json: @self_assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @self_assessment.update_attributes(params[:self_assessment])
        flash[:success] = "Self Assessment was successfully updated."
        format.html { redirect_to summary_review_path(@review) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @self_assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @self_assessment.destroy

    respond_to do |format|
      format.html { redirect_to summary_review_path(@review) }
      format.json { head :no_content }
    end
  end
end
