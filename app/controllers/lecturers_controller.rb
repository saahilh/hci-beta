class LecturersController < ActionController::Base
  include AuthenticationHelper

  before_action :set_lecturer, only: [:show]

  def login
    @lecturer = Lecturer.find_by(email: params[:email])

    if(!@lecturer.nil? && @lecturer.authenticate(Digest::SHA1.hexdigest(params[:pw])))
      cookies[:logged_in] = { value: @lecturer.id, expires: 3.hours.from_now }
      render json: { data: { redirect: "/lecturers/#{@lecturer.id}" } }
    else
      render json: { data: { msg: "Invalid credentials entered" } }
    end
  end

  def show
  	render 'lecturer_profile', locals:{ lecturer: @lecturer }
  end

  def logout
    cookies.delete :logged_in
    redirect_to "/index"
  end

  def create
    lecturer = Lecturer.create(lecturer_creation_params)
    render json: { data:{ errors: lecturer.persisted? ? nil : lecturer.errors.full_messages } }
  end

  def lecturer_creation_params
    params.require(:lecturer).permit(:name, :email, :password, :password_confirmation)
  end
end