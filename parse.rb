require 'open-uri'
require 'nokogiri'
require './Classes/Vacancy.rb'

html = URI.open("https://www.rabota.md/ru/vacancies/category/it")
parsed_html = Nokogiri::HTML5(html)

companies = parsed_html.css(".vip-vacancy")
companies_with_new_vacancies = companies.select do |comp|
  has_new_vacancies = false
  vacancies = comp.css("ul.vip-vacancies_list > li")
  # puts vacancies
  # puts "============="
  vacancies.each do |vacancy|
    unless vacancy.css("i.new").empty?
      has_new_vacancies = true
      break
    end
  end
  has_new_vacancies
end

puts "Total companies: " + companies_with_new_vacancies.count.to_s
puts

# Show only the new vacancies
companies_with_new_vacancies.each do |comp|
  vacancies = comp.css("ul.vip-vacancies_list > li")
  new_vacancies = vacancies.select do |vacancy|
    !(vacancy.css("i.new").empty?)
  end
  puts comp.css("a.vip_company--name").children[0].text.strip + " (Total new vacancies: #{new_vacancies.count})"
  # p new_vacancies.class
  new_vacancies.each do |vacancy|
      puts vacancy.css("div > a").children[0].text
  end
  puts "================"
end
