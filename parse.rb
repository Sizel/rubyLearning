require 'open-uri'
require 'nokogiri'
require 'time'
require 'caxlsx'
require './Classes/Vacancy.rb'
require './Classes/Company.rb'
require './Classes/ExcelWriter.rb'

html = URI.open("https://www.rabota.md/ru/vacancies/category/it")
parsed_html = Nokogiri::HTML5(html)
excel_writer = ExcelWriter.new("./Vacancies.xlsx")
time_before = Time.now

companies = parsed_html.css(".vip-vacancy").map do |company_html|
  company_title = company_html.at_css("a.vip_company--name").children[0].text.strip
  vacancies_html = company_html.css("ul.vip-vacancies_list > li")
  vacancies = vacancies_html.map do |vacancy_html|
    vacancy_title = vacancy_html.at_css("div > a").children[0].text
    vacancy_is_new = !(vacancy_html.at_css("i.new").empty?)
    Vacancy.new(vacancy_title, vacancy_is_new)
  end
  Company.new(company_title, vacancies)
end

excel_writer.add_row(%w(Company Vacancy Is\ new))
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
    end
    # p row
    excel_writer.add_row(row)
  end
  # puts "================"
end

excel_writer.write

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
