# frozen_string_literal: true

module Charitable
  extend ActiveSupport::Concern

  included do
    has_many :charitable_categories, as: :charitable, dependent: :delete_all
    has_many :charity_causes, through: :charitable_categories
  end

  def insert_charitable_categories(charity_causes)
    return unless charity_causes.present?

    charity_cause_ids = charity_causes.map { |c| find_id_by_charity_cause(c) }
    charitable_categories = charity_cause_ids.filter_map { |id| build_charitable_category(id) }

    return unless charitable_categories.present?

    CharitableCategory.upsert_all(charitable_categories, unique_by: :index_charitable_categories)
  end

  private

  def find_id_by_charity_cause(charity_cause)
    record = charity_cause_records.find { |r| r[:name] == charity_cause }
    record[:id] if record
  end

  def charity_cause_records
    @charity_cause_records ||= CharityCause.pluck(:id, :name).map { |id, name| { id: id, name: name } }
  end

  def build_charitable_category(charity_cause_id)
    return unless charity_cause_id.present?

    {
      charitable_id: self.id,
      charitable_type: self.class.name,
      charity_cause_id: charity_cause_id
    }
  end
end
