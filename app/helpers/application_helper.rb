module ApplicationHelper
  def flash_design(type)
    case type.to_sym
    when :success then "flex items-center text-sky-400"
    when :danger then "flex items-center text-rose-400"
    end
  end
end
