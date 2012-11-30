class SelfAssessmentsController < ApplicationController
  load_and_authorize_resource
  # GET /self_assessments
  # GET /self_assessments.json
  def index
    @self_assessments = SelfAssessment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @self_assessments }
    end
  end

  # GET /self_assessments/1
  # GET /self_assessments/1.json
  def show
    @self_assessment = SelfAssessment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @self_assessment }
    end
  end

  # GET /self_assessments/new
  # GET /self_assessments/new.json
  def new
    @self_assessment = SelfAssessment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @self_assessment }
    end
  end

  # GET /self_assessments/1/edit
  def edit
    @self_assessment = SelfAssessment.find(params[:id])
  end

  # POST /self_assessments
  # POST /self_assessments.json
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

  # PUT /self_assessments/1
  # PUT /self_assessments/1.json
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

  # DELETE /self_assessments/1
  # DELETE /self_assessments/1.json
  def destroy
    @self_assessment = SelfAssessment.find(params[:id])
    @self_assessment.destroy

    respond_to do |format|
      format.html { redirect_to self_assessments_url }
      format.json { head :no_content }
    end
  end
end
