class ScientistsController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    
    
    def index 
        scientists = Scientist.all
        render json: scientists,
         status: :ok
    end

    def show
        scientist = find_scientist
        render json: scientist, serializer: ScientistWithPlanetsSerializer, status: :ok
    end

    def create 
        scientist = Scientist.create!(scientist_params)
        render json: scientist,  status: :created
    end

    def update 
        scientist = find_scientist
        scientist.update!(scientist_params)
        render json: scientist, status: :accepted

    end
    #need to created dependent destroy in the scientist.rb model so that missions will be deleted with the scientist
    def destroy
        scientist = find_scientist
        scientist.destroy
        head :no_content
    end

    private

    def scientist_params
        params.permit(:name, :field_of_study, :avatar)
    end

    def find_scientist
        Scientist.find(params[:id])
    end

    def render_not_found_response
        render json: {"error": "Scientist not found"}, status: :not_found

    end

    def render_unprocessable_entity
        render json: {"errors":["validation errors"]}, status: :unprocessable_entity
    end
end
