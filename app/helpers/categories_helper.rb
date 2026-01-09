module CategoriesHelper
  def category_badge(category)
    return nil unless category

    content_tag(:span,
      category.name,
      class: "badge",
      style: "background-color: #{category.color};"
    )
  end

  def category_color_circle(category, size: 40)
    return nil unless category&.color.present?

    content_tag(:div,
      "",
      class: "rounded-circle me-3",
      style: "width: #{size}px; height: #{size}px; background-color: #{category.color};"
    )
  end

  def category_availability_count(category)
    count = category.availabilities.count
    "#{count} #{count == 1 ? 'clase' : 'clases'}"
  end

  def render_categories_or_empty(categories, empty_message: "No hay categorías disponibles.", &block)
    if categories.any?
      capture(&block)
    else
      content_tag(:div, empty_message, class: "alert alert-info")
    end
  end
end
