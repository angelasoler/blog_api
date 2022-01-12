require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validation#' do
    it 'validate status definition' do
      should define_enum_for(:status).with_values([:published, :archived])
    end
  
    it 'validate presence of attr' do
      should validate_presence_of(:title)
      should validate_presence_of(:content)
      should validate_presence_of(:status)
      should validate_presence_of(:user_id)
    end
  end
end
