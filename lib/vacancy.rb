class Vacancy
  attr_accessor :title, :is_new
  attr_reader :link

  def initialize(title, is_new, link)
    @title = title
    @is_new = is_new
    @link = link
  end
end
