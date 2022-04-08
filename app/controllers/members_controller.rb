# frozen_string_literal: true

class MembersController < ApplicationController
  def index
    @members = current_member.organization.members
  end
end
