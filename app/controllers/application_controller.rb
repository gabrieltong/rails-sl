class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # 根据分页的数量
  # require @page
  # require @per_page
  # set @collection
  def paginate(collection)
    collection.paginate(:page=>@page,:per_page=>@per_page)
  end    
end
