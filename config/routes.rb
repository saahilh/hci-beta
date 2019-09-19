Rails.application.routes.draw do
  resources :courses do
    resources :polls
    resources :questions
  end

  resources :questions

  resources :lecturers

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/' => "application#index"
  get 'index' => "application#index"

  get 'poll_class' => "application#poll_class"

  get 'courses/*id/ask_question' => "courses#show"
  get "login" => "applcation#index"
  get 'select_course' => "application#index"

  post "courses/*course_id/polls/*id/end" => "polls#end"
  get "courses/*course_id/polls/*id/end" => "polls#show"

  post "/questions/*id/in_class" => "questions#in_class"
  post "/questions/*id/after_class" => "questions#after_class"
  post "/questions/*id/upvote" => "questions#upvote"
  post "/questions/*id/downvote" => "questions#downvote"
  post "/questions/*id/flag" => "questions#flag"
  
  post "/lecturers/logout" => "lecturers#logout"

  post "polls/*id/end" => "polls#end"
  post "polls/*id/options/*option_id" => "polls#answer"

  post "login" => "lecturers#login"
  post 'select_course' => "courses#select_course"
end
