module DashboardHelper
  @@stat_card_class = "col-md-6 col-lg-3 mb-3"
  def student_stat_cards(upcoming_bookings_count, total_bookings_count)
    safe_join([
      content_tag(:div, class: @@stat_card_class) do
        dashboard_stat_card(
          title: "Clases agendadas",
          value: upcoming_bookings_count,
          bg_class: "bg-primary"
        )
      end,
      content_tag(:div, class: @@stat_card_class) do
        dashboard_stat_card(
          title: "Todas mis clases",
          value: total_bookings_count,
          bg_class: "bg-success"
        )
      end,
      content_tag(:div, class: @@stat_card_class) do
        dashboard_stat_card(
          title: "Mis reservas",
          value: "Ver todas",
          bg_class: "bg-info",
          link: students_bookings_path
        )
      end,
      content_tag(:div, class: @@stat_card_class) do
        dashboard_stat_card(
          title: "Explorar mentores",
          value: "Buscar",
          bg_class: "bg-warning",
          link: mentors_path
        )
      end
    ])
  end

  def mentor_stat_cards(availabilities_count, upcoming_bookings_count)
    safe_join([
      content_tag(:div, class: @@stat_card_class) do
        dashboard_stat_card(
          title: "Mis horarios",
          value: availabilities_count,
          bg_class: "bg-primary"
        )
      end,
      content_tag(:div, class: @@stat_card_class) do
        dashboard_stat_card(
          title: "Próximas Clases",
          value: upcoming_bookings_count,
          bg_class: "bg-success"
        )
      end,
      content_tag(:div, class: @@stat_card_class) do
        dashboard_stat_card(
          title: "Disponibilidad",
          value: "Gestionar",
          bg_class: "bg-info",
          link: mentors_availabilities_path
        )
      end,
      content_tag(:div, class: @@stat_card_class) do
        dashboard_stat_card(
          title: "Clases",
          value: "Ver todas",
          bg_class: "bg-warning",
          link: mentors_bookings_path
        )
      end
    ])
  end
end
