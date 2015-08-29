module ApplicationHelper
  def trim(num)
    i = num.to_i
    f = num.to_f
    i == f ? i : f
  end
end
