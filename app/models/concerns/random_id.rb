# frozen_string_literal: true

module RandomId
  extend ActiveSupport::Concern

  included do
    before_create :set_random_id
  end

  class_methods do
    attr_reader :no_prefix

    def random_id(name = nil, prefix: nil, separator: nil, length: nil, no_prefix: false)
      @random_id_name = name
      @random_id_prefix = prefix
      @random_id_separator = separator
      @random_id_length = length
      @no_prefix = no_prefix
    end

    def random_id_name
      @random_id_name || "#{name.underscore}_id"
    end

    def random_id_prefix
      return nil if no_prefix

      @random_id_prefix || name.downcase[0, 2]
    end

    def random_id_separator
      return nil if no_prefix

      @random_id_separator || "_"
    end

    def random_id_length
      @random_id_length || 24
    end
  end

  private

  def set_random_id
    public_send("#{self.class.random_id_name}=", generate_random_id)
  end

  def generate_random_id
    loop do
      random_id = build_random_id
      break random_id unless self.class.exists?(["#{self.class.random_id_name} = ?", random_id])
    end
  end

  def build_random_id
    "#{self.class.random_id_prefix}#{self.class.random_id_separator}#{SecureRandom.base58(self.class.random_id_length)}"
  end
end
