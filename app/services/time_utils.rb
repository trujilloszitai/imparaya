class TimeUtils
  def self.combine(date, time)
    DateTime.new(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.min,
      time.sec,
      time.zone
    )
  end
end
