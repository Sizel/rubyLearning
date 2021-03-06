require 'benchmark'
require './lib/vacancy.rb'
require './lib/company.rb'
require './lib/companies_writer.rb'
begin
  require './lib/it_vacancies_scraper.rb'
rescue SocketError => e
  puts e.message
  exit
end

companies_writer = CompaniesWriter.new("./Vacancies.xlsx", %w(Company Vacancy Is\ new Link))
it_vacancies_scraper = ITVacanciesScraper.new

Benchmark.bm do |x|
  x.report do
    companies = it_vacancies_scraper.get_all_companies
    companies_writer.write_companies(companies)
  end
end
