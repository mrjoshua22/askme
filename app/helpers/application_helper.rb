module ApplicationHelper
  def inclination(count, one, few, many)
    return many if (count % 100).between?(11,14)

    case count % 10
    when 1 then one
    when 2..4 then few
    else
      many
    end
  end

  def navbar_color
    user_header_color = "header_color_#{current_user.id}" if current_user.present?

    if session[user_header_color].present?
      "style=background-color:#{session[user_header_color]}"
    end
  end
end
