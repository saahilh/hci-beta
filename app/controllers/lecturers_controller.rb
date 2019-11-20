class LecturersController < ActionController::Base
  include AuthenticationHelper

  before_action :set_lecturer, only: [:show]

  def login
    @lecturer = Lecturer.find_by(email: params[:email])

    if(!@lecturer.nil? && @lecturer.authenticate(params[:pw]))
      session[:lecturer_id] = @lecturer.id

      render json: { data: { redirect: "/lecturers/#{@lecturer.id}" } }
    else
      render json: { data: { msg: "Invalid credentials entered" } }
    end
  end

  def show
  	render 'lecturer_profile', locals: { lecturer: @lecturer }
  end

  def logout
    session[:lecturer_id] = nil

    redirect_to "/index"
  end

  def create
    lecturer = Lecturer.create(lecturer_creation_params)

    render json: { data:{ errors: lecturer.errors.full_messages } }
  end

  def lecturer_creation_params
    params.require(:lecturer).permit(:name, :email, :password, :password_confirmation)
  end
end
