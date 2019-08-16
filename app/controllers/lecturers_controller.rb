class LecturersController < ActionController::Base
  include AuthenticationHelper

  before_action :set_lecturer, only: [:show]

  def login
    @lecturer = Lecturer.find_by(email: params[:email])

    sha1_password = Digest::SHA1.hexdigest("#{params[:pw]}")

    if(!@lecturer.nil? && BCrypt::Password.new(@lecturer.password_digest) == sha1_password)
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
    lecturer = Lecturer.create(lecturer_params)
    render json: { data:{ errors: lecturer.persisted? ? nil : lecturer.errors.full_messages } }
  end

  def lecturer_params
    params.require(:lecturer).permit(:name, :email, :password, :password_confirmation)
  end
end