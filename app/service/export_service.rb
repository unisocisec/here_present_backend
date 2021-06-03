# frozen_string_literal: true

class ExportService
  def export_teachers(teachers:)
    file = write_in_file(data_for_export: teachers.generate_csv, title_export: I18n.t('file_name_export.teachers'))
    response_export(file: file)
  end

  def export_classrooms(classrooms:)
    file = write_in_file(data_for_export: classrooms.generate_csv, title_export: I18n.t('file_name_export.call_lists'))
    response_export(file: file)
  end

  def export_call_lists(call_lists:)
    file = write_in_file(data_for_export: call_lists.generate_csv, title_export: I18n.t('file_name_export.call_lists'))
    response_export(file: file)
  end

  def export_student_answers(student_answers:)
    file = write_in_file(data_for_export: student_answers.generate_csv, title_export: I18n.t('file_name_export.student_answers'))
    response_export(file: file)
  end

  def write_in_file(data_for_export:, title_export:)
    path = FileUtils.mkdir_p "public/uploads/exports/#{Time.now.strftime('%Y-%d-%m')}"
    file = File.open("#{path.first}/#{Time.now.strftime('%Y-%d-%m')}-#{title_export}-#{SecureRandom.uuid}.csv".to_s, 'wb:iso-8859-15')
    file.binmode
    file.write(data_for_export)
    file.close
    file
  end

  def response_export(file:)
    real_path = "#{ENV['ENV_URL']}/" + file.path.to_s.gsub('public/', '')
    { path: real_path, status: :ok, message: 'Exportação com sucesso' }
  end
end
