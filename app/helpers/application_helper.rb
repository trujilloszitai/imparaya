module ApplicationHelper
  include CalendarHelper

  def clickable_card_link(url, classes: "card", **options, &block)
    content_tag(:div,
      class: "#{classes} clickable",
      data: {
        controller: "nav",
        nav_url_value: url,
        action: "click->nav#goToUrl"
      },
      **options,
      &block
    )
  end

  def user_greeting(user)
    "Bienvenido, #{user.first_name}"
  end

  def dashboard_stat_card(title:, value:, bg_class: "bg-primary", link: nil)
    card_classes = "card text-white #{bg_class}"

    card_content = content_tag(:div, class: card_classes) do
      content_tag(:div, class: "card-body") do
        content_tag(:h5, title, class: "card-title") +
        content_tag(:h2, value)
      end
    end

    if link
      link_to(card_content, link, class: "text-decoration-none")
    else
      card_content
    end
  end

  def empty_state_message(message, link_text: nil, link_path: nil)
    content_tag(:div, class: "alert alert-info") do
      if link_text && link_path
        safe_join([ message, " ", link_to(link_text, link_path, class: "alert-link") ])
      else
        message
      end
    end
  end

  def truncate_biography(text, length: 150)
    if text.present?
      truncate(text, length: length)
    else
      content_tag(:em, "Mentor profesional")
    end
  end

  def hover_shadow_classes
    "shadow-sm hover-shadow"
  end
end
