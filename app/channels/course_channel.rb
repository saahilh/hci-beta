class CourseChannel < ApplicationCable::Channel
	def subscribed
		course = Course.where(name: params[:room]).first
		stream_for course
		CourseChannel.broadcast_to(course, connected: true)
	end
end