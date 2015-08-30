module ApplicationHelper
  def trim(num)
    return nil if num.nil?
    i = num.to_i
    f = num.to_f
    i == f ? i : f
  end
end
