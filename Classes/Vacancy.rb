class Vacancy
  attr_accessor :title, :is_new

  def initialize(title, is_new=true)
    @title = title
    @is_new = is_new
  end
end