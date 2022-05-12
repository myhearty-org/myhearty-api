# frozen_string_literal: true

class Seeder
  def initialize
    if Rails.env.production?
      puts "Can't run seeds in production"

      exit 1
    end

    @counter = 0
  end

  def create(message)
    @counter += 1
    puts "  #{@counter}. #{message}."

    yield
  end

  def create_if_none(klass, count = nil)
    @counter += 1
    plural = klass.name.pluralize.titlecase

    if klass.none?
      message = ["Creating", count, plural].compact.join(" ")
      puts "  #{@counter}. #{message}."

      yield
    else
      puts "  #{@counter}. #{plural} already exist. Skipping."
    end
  end

  def create_if_not_exist(klass, attribute_name, attribute_value)
    record = klass.find_by("#{attribute_name}": attribute_value)

    if record.nil?
      puts "  #{klass} with #{attribute_name} = #{attribute_value} not found, proceeding..."

      yield
    else
      puts "  #{klass} with #{attribute_name} = #{attribute_value} found, skipping."
    end
  end
end
