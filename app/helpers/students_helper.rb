module StudentsHelper
  def student_profile_link(student)
    link_to mentors_student_path(student) do
      content_tag(:span, student.full_name) +
      tag.br +
      content_tag(:small, student.email, class: "text-muted")
    end
  end

  def student_table_info(student)
    content_tag(:div) do
      student_profile_link(student)
    end
  end
end
