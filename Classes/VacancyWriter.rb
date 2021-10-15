require 'caxlsx'

class VacancyWriter
  @file_path
  @package
  @worksheet

  def initialize(file_path, column_names, worksheet_name="Worksheet 1")
    @file_path = file_path
    @package = Axlsx::Package.new()
    @worksheet = @package.workbook.add_worksheet(:name => worksheet_name) do |sheet|
      sheet.add_row(column_names)
    end
  end

  def add_vacancy(data)
    @worksheet.add_row(data) do |row|
      @worksheet.add_hyperlink(:location => data.last, :ref => row.cells.last)
    end
  end

  def write
    @package.serialize(@file_path)
  end
end