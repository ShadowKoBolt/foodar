module ApplicationHelper
  def trim(num)
    i, f = num.to_i, num.to_f
    i == f ? i : f
  end
end
