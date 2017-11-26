class LecturersController < ActionController::Base

  def login
    lecturer = Lecturer.where(email: params[:email])
    if(lecturer.count != 0 && lecturer.first.password==params[:pw])
      cookies[:logged_in] = { value: lecturer.first.id, expires: 3.hours.from_now }
      render json: { data: { redirect: "/lecturers/#{lecturer.first.id}" } }
    else
      render json: { data: { msg: "Invalid credentials entered" } }
    end
  end

  def show
    if(cookies[:logged_in].to_s==params[:id].to_s)
  	  render 'prof-ile', locals:{ lecturer: Lecturer.find(params[:id]) }
    else
      render '/message', locals: { message: "Error: not logged in" }
    end
  end

  def logout
    cookies.delete :logged_in
    render '/message', locals: { message: "Successfully logged out" }
  end

  def create
    success = false

    if(params[:pw]!=params[:cpw])
      msg = "Passwords do not match"
    elsif params[:pw].blank?||params[:name].blank?||params[:email].blank?
      msg = "Left a field blank"
    elsif Lecturer.where(email: params[:email]).count!=0
      msg = "Account with that mail already exists"
    else
      msg = "Successfully created account"
      Lecturer.create(name: params[:name], password: params[:pw], email: params[:email])
      success = true
    end
    render json: { data:{msg: msg, success: success } }
  end

end