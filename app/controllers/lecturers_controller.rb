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
  	render 'prof-ile', locals:{ lecturer: @lecturer }
  end

  def logout
    cookies.delete :logged_in
    redirect_to "/index"
  end

  def create
    success = false

    if(!(params[:pw].blank? || params[:cpw].blank?))
      params[:pw] = Digest::SHA1.hexdigest("#{params[:pw]}")
      params[:cpw] = Digest::SHA1.hexdigest("#{params[:cpw]}")

      if(params[:pw]!=params[:cpw])
        msg = "Passwords do not match"
      elsif params[:pw].blank?||params[:name].blank?||params[:email].blank?
        msg = "Left a field blank"
      elsif Lecturer.where(email: params[:email]).count!=0
        msg = "Account with that mail already exists"
      else
        msg = "Successfully created account"
        Lecturer.create(name: params[:name], password_digest: BCrypt::Password.create(params[:pw]).to_s, email: params[:email])
        success = true
      end
    else
      msg = "Password or password confirmation is blank"
    end

    render json: { data:{ msg: msg, success: success } }
  end
end