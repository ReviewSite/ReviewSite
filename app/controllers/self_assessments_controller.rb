class SelfAssessmentsController < ApplicationController
  load_resource :review
  load_and_authorize_resource :through => :review

  def new
    @self_assessment.junior_consultant = @review.junior_consultant

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @self_assessment }
    end
  end

  def edit
  end

  def create
    @self_assessment.junior_consultant = @review.junior_consultant

    respond_to do |format|
      if @self_assessment.save
        format.html { redirect_to summary_review_path(@review), notice: 'Self assessment was successfully created.' }
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
        format.html { redirect_to summary_review_path(@review), notice: 'Self assessment was successfully updated.' }
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
