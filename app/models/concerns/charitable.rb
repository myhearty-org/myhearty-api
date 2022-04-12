# frozen_string_literal: true

module Charitable
  extend ActiveSupport::Concern

  attr_accessor :categories

  included do
    after_save :insert_charity_causes

    has_many :charitables_charity_causes, as: :charitable, dependent: :delete_all
    has_many :charity_causes, through: :charitables_charity_causes
  end

  def insert_charity_causes
    return unless categories

    CharitablesCharityCause.where(charitable_id: self.id, charitable_type: self.class.name).delete_all

    charity_causes = categories
    charity_cause_ids = charity_causes.map { |c| find_id_by_charity_cause(c) }
    charitables_charity_causes = charity_cause_ids.filter_map { |id| build_charitables_charity_cause(id) }

    return unless charitables_charity_causes.present?

    CharitablesCharityCause.upsert_all(charitables_charity_causes, unique_by: :index_charitables_charity_causes)
  end

  private

  def find_id_by_charity_cause(charity_cause)
    record = charity_cause_records.find { |r| r[:name] == charity_cause }
    record[:id] if record
  end

  def charity_cause_records
    @charity_cause_records ||= CharityCause.pluck(:id, :name).map { |id, name| { id: id, name: name } }
  end

  def build_charitables_charity_cause(charity_cause_id)
    return unless charity_cause_id.present?

    {
      charitable_id: self.id,
      charitable_type: self.class.name,
      charity_cause_id: charity_cause_id
    }
  end
end
