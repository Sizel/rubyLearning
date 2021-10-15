require 'open-uri'
require 'nokogiri'
require 'time'
require 'caxlsx'
require './Classes/Vacancy.rb'
require './Classes/Company.rb'
require './Classes/VacancyWriter.rb'

URL = "https://www.rabota.md"
html = URI.open(URL + "/ru/vacancies/category/it")
parsed_html = Nokogiri::HTML5(html)
vacancy_writer = VacancyWriter.new("./Vacancies.xlsx", %w(Company Vacancy Is\ new Link))
time_before = Time.now

companies = parsed_html.css(".vip-vacancy").map do |company_html|
  company_title = company_html.at_css("a.vip_company--name").children[0].text.strip
  vacancies_html = company_html.css("ul.vip-vacancies_list > li")
  vacancies = vacancies_html.map do |vacancy_html|
    vacancy_title = vacancy_html.at_css("div > a").children[0].text.strip
    vacancy_is_new = !(vacancy_html.at_css("i.new").nil?)
    vacancy_link = URL + vacancy_html.at_css("div > a")["href"]
    Vacancy.new(vacancy_title, vacancy_is_new, vacancy_link)
  end
  Company.new(company_title, vacancies)
end

companies.each do |comp|
  # puts "Company: #{comp.title}"
  # puts "Vacancies:"
  comp.vacancies.each do |vacancy|
    row = []
    # p row
    row << comp.title
    # p row
    row << vacancy.title
    # p row
    if vacancy.is_new
      # puts vacancy.title + " (NEW!!!)"
      row << "New!!!"
      # p row
    else
      row << ""
    end
    # p row
    row << vacancy.link
    vacancy_writer.add_vacancy(row)
  end
  # puts "================"
end

vacancy_writer.write

# Show how much time did the execution take
time_after= Time.now
duration = time_after - time_before
puts duration

# # Show only the new vacancies
# companies_with_new_vacancies.each do |comp|
#   vacancies = comp.css("ul.vip-vacancies_list > li")
#   new_vacancies = vacancies.select do |vacancy|
#     !(vacancy.css("i.new").empty?)
#   end
#   puts comp.css("a.vip_company--name").children[0].text.strip + " (Total new vacancies: #{new_vacancies.count})"
#   # p new_vacancies.class
#   new_vacancies.each do |vacancy|
#       puts vacancy.css("div > a").children[0].text
#   end
#   puts "================"
# end
