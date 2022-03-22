# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :organization

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable
end
