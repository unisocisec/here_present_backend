# frozen_string_literal: true

require 'csv'

module GenerateCsv
  extend ActiveSupport::Concern

  class_methods do
    def generate_csv
      CSV.generate(headers: true, col_sep: ';', force_quotes: true) do |csv|
        csv << column_names_to_export

        all.each do |record|
          csv << record.export_attributes.values
        end
      end
    end
  end
end
