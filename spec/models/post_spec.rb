require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validation#' do
    it 'validate presence of attr' do
      should { validate_presence_of(:title) }
      should { validate_presence_of(:content) }
    end

    it 'validate status definition' do
      should define_enum_for(:status).with_values([:published, :archived])
    end
  end
end
