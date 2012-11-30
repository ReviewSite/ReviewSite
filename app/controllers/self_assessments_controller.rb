class SelfAssessmentsController < ApplicationController
  load_and_authorize_resource

  def show
    @self_assessment = SelfAssessment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @self_assessment }
    end
  end

  def new
    review = Review.find(params[:review])
    junior_consultant = review.junior_consultant
    @self_assessment = SelfAssessment.new(review: review, junior_consultant: junior_consultant)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @self_assessment }
    end
  end

  def edit
    @self_assessment = SelfAssessment.find(params[:id])
  end

  def create
    @self_assessment = SelfAssessment.new(params[:self_assessment])

    respond_to do |format|
      if @self_assessment.save
        format.html { redirect_to @self_assessment, notice: 'Self assessment was successfully created.' }
        format.json { render json: @self_assessment, status: :created, location: @self_assessment }
      else
        format.html { render action: "new" }
        format.json { render json: @self_assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @self_assessment = SelfAssessment.find(params[:id])

    respond_to do |format|
      if @self_assessment.update_attributes(params[:self_assessment])
        format.html { redirect_to @self_assessment, notice: 'Self assessment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @self_assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @self_assessment = SelfAssessment.find(params[:id])
    @self_assessment.destroy

    respond_to do |format|
      format.html { redirect_to self_assessments_url }
      format.json { head :no_content }
    end
  end
end
