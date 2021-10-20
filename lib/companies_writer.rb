require 'caxlsx'

class CompaniesWriter
  def initialize(file_path, column_names, worksheet_name = "Worksheet 1")
    @file_path = file_path
    @package = Axlsx::Package.new()
    @worksheet = @package.workbook.add_worksheet(:name => worksheet_name) do |sheet|
      sheet.add_row(column_names)
    end
  end

  def write_companies(companies)
    companies.each do |comp|
      comp.vacancies.each do |vacancy|
        row = []
        row << comp.title
        row << vacancy.title
        if vacancy.is_new
          row << "New!!!"
        else
          row << ""
        end
        row << vacancy.link
        add_vacancy(row)
      end
    end

    write
  end

  private

  def add_vacancy(vacancy)
    @worksheet.add_row(vacancy) do |row|
      @worksheet.add_hyperlink(:location => vacancy.last, :ref => row.cells.last)
    end
  end

  def write
    @package.serialize(@file_path)
  end
end
