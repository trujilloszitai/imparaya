module CalendarHelper
  def month_calendar(options = {}, &block)
    raise "month_calendar requires a block" unless block_given?

    # Configuración por defecto
    start_date = options.fetch(:start_date, Date.today.beginning_of_month.beginning_of_week)

    content_tag :div, class: "simple-calendar" do
      calendar_table(start_date, &block)
    end
  end

  private

  def calendar_table(start_date, &block)
    content_tag :table, class: "table table-bordered" do
      calendar_header + calendar_body(start_date, &block)
    end
  end

  def calendar_header
    content_tag :thead do
      content_tag :tr do
        Date::DAYNAMES.map { |day|
          content_tag :th, day, class: "text-center"
        }.join.html_safe
      end
    end
  end

  def calendar_body(start_date, &block)
    weeks = []
    current_date = start_date

    5.times do
      weeks << calendar_week(current_date, &block)
      current_date += 7.days
    end

    content_tag :tbody do
      weeks.join.html_safe
    end
  end

  def calendar_week(start_date, &block)
    content_tag :tr do
      (0..6).map { |i|
        date = start_date + i.days
        content_tag :td, class: calendar_day_classes(date) do
          block.call(date)
        end
      }.join.html_safe
    end
  end

  def calendar_day_classes(date)
    classes = [ "calendar-day" ]
    classes << "today" if date == Date.today
    classes << "other-month" if date.month != Date.today.month
    classes.join(" ")
  end
end
