module ApplicationHelper
  def time_of_day_greeting
    current_hour = Time.now.hour
    case current_hour
    when 12..17
      "Good afternoon"
    when 18..23
      "Good evening"
    else
      "Good morning"
    end
  end
end
