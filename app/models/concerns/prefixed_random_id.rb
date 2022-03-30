# frozen_string_literal: true

module PrefixedRandomId
  extend ActiveSupport::Concern

  included do
    before_create :set_prefixed_random_id
  end

  class_methods do
    attr_writer :id_name, :id_prefix, :id_separator, :id_length

    def id_name
      @id_name || "#{name.downcase}_id"
    end

    def id_prefix
      @id_prefix || name.downcase[0, 2]
    end

    def id_separator
      @id_separator || "_"
    end

    def id_length
      @id_length || 24
    end
  end

  private

  def set_prefixed_random_id
    public_send("#{self.class.id_name}=", generate_prefixed_random_id)
  end

  def generate_prefixed_random_id
    loop do
      prefixed_random_id = build_prefixed_random_id
      break prefixed_random_id unless self.class.exists?(["#{self.class.id_name} = ?", prefixed_random_id])
    end
  end

  def build_prefixed_random_id
    "#{self.class.id_prefix}#{self.class.id_separator}#{SecureRandom.base58(self.class.id_length)}"
  end
end
