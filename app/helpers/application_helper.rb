module ApplicationHelper
	def sorted_class(column_name)
		session[:sort] == column_name ? "hilite" :""
	end
end
