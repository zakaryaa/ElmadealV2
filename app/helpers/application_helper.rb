module ApplicationHelper
  def active_class?(test_path)
     return "active" if request.path == test_path
  end

  def path_contains? param
      request.path_info.include?(param)
  end

end