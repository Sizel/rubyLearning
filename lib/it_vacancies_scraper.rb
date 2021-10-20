require 'open-uri'
require 'nokogiri'

class ITVacanciesScraper
  URL = "https://www.rabota.md"
  HTML = URI.open(URL + "/ru/vacancies/category/it")
  DOM = Nokogiri::HTML5(HTML)

  def get_all_companies
    DOM.css(".vip-vacancy").map do |company_html|
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
  end
end
