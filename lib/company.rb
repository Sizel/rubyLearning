class Company
  attr_reader :title
  attr_accessor :vacancies

  # attr_reader :description

  def initialize(title, vacancies)
    @title = title
    @vacancies = vacancies
  end
end
