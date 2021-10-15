require 'caxlsx'

class ExcelWriter
  @file_path
  @package
  @worksheet

  def initialize(file_path, worksheet_name="Worksheet 1")
    @file_path = file_path
    @package = Axlsx::Package.new()
    @worksheet = @package.workbook.add_worksheet(:name => worksheet_name)
  end

  def add_row(data)
    @worksheet.add_row(data)
  end

  def write
    @package.serialize(@file_path)
  end
end