# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
class AddInitialUsers < ActiveRecord::Migration[8.1]
  def up
    10.times do |i|
      User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: "mentor#{i + 1}@test.com",
        password: "password",
        role: :mentor,
        biography: Faker::Lorem.paragraph(sentence_count: 3),
        phone: Faker::PhoneNumber.cell_phone_in_e164)
    end
    20.times do |i|
      User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: "student#{i + 1}@test.com",
        password: "password",
        role: :student,
        biography: Faker::Lorem.paragraph(sentence_count: 3),
        phone: Faker::PhoneNumber.cell_phone_in_e164)
    end
  end

  def down
    User.delete_all
    User.reset_pk_sequence
  end
end

class AddInitialCategories < ActiveRecord::Migration[8.1]
  def up
    10.times do |i|
      Category.create(
        name: Faker::Educator.unique.subject,
        color: Colors::DEFAULTS.sample
      )
    end
  end

  def down
    Category.delete_all
    Category.reset_pk_sequence
  end
end

class AddInitialAvailabilities < ActiveRecord::Migration[8.1]
  def up
    User.mentors.each do |mentor|
      (0..6).each do |day_of_week|
        Faker::Config.random = Random.new(mentor.id + day_of_week)
        infinite_capacity = Faker::Boolean.boolean(true_ratio: 0.1)

        from_time = Time.zone.today.change(hour: 8)
        to_time   = Time.zone.today.change(hour: 20)
        base_time = Faker::Time.between(from: from_time, to: to_time).change(min: 0, sec: 0).to_time

        Availability.find_or_create_by!(
          mentor: mentor,
          category: Category.all.sample,
          day_of_week: day_of_week,
          starts_at: base_time,
          ends_at: base_time + 2.hours,
          capacity: infinite_capacity ? nil : Faker::Number.within(range: 1..30),
          price_per_hour: Faker::Number.decimal(l_digits: 4, r_digits: 2),
          description: "Disponibilidad de #{mentor.first_name + ' ' + mentor.last_name}"
        )
      end
    end
  end

  def down
    Availability.delete_all
    Availability.reset_pk_sequence
  end
end

class AddInitialBookings < ActiveRecord::Migration[8.1]
  def up
    students = User.students.to_a
    Availability.all.sample(30).each do |availability|
      student = students.sample
      booking_date = Time.zone.now.to_date + ((availability.day_of_week - Time.zone.now.wday) % 7)
      start_datetime = booking_date.to_datetime.change(hour: availability.starts_at.hour, min: availability.starts_at.min, sec: 0, offset: Time.zone.formatted_offset)
      end_datetime = booking_date.to_datetime.change(hour: availability.ends_at.hour, min: availability.ends_at.min, sec: 0, offset: Time.zone.formatted_offset)

      Booking.find_or_create_by!(
        availability: availability,
        starts_at: start_datetime,
        ends_at: end_datetime,
        price: (((availability.ends_at - availability.starts_at) / 3600) * availability.price_per_hour),
        student: student,
        status: 0
      )
    end
  end

  def down
    Booking.delete_all
    Booking.reset_pk_sequence
  end
end

AddInitialUsers.new.up
AddInitialCategories.new.up
AddInitialAvailabilities.new.up
AddInitialBookings.new.up
