module MentorsHelper
  def mentor_availability_count(mentor)
    count = mentor.availabilities.count
    "#{count} #{count == 1 ? 'horario disponible' : 'horarios disponibles'}"
  end

  def mentor_contact_info(mentor)
    return nil unless user_signed_in?

    content_tag(:div, class: "mt-3") do
      content_tag(:h5, "Información de Contacto") +
      content_tag(:p) do
        content_tag(:strong, "Email:") + " #{mentor.email}" +
        tag.br +
        content_tag(:strong, "Teléfono:") + " #{mentor.phone}"
      end
    end
  end

  def mentor_about_section(mentor)
    return nil unless mentor.biography.present?

    content_tag(:div, class: "mt-3") do
      content_tag(:h5, "Acerca de") +
      content_tag(:p, mentor.biography, class: "text-muted")
    end
  end

  def mentor_primary_action_button(mentor)
    if user_signed_in? && current_user.student?
      link_to "Ver Clases Disponibles",
              weekly_schedule_mentor_path(mentor.id),
              class: "btn btn-primary w-100 mb-2"
    else
      link_to "Iniciar Sesión para Reservar",
              new_user_session_path,
              class: "btn btn-primary w-100"
    end
  end

  def render_mentors_or_empty(mentors, empty_message: "No hay mentores disponibles en este momento.", &block)
    if mentors.any?
      capture(&block)
    else
      content_tag(:div, empty_message, class: "alert alert-info")
    end
  end
end
