require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with attributes' do
      expect(FactoryBot.build(:task)).to be_valid
    end

    it 'is invalid without title' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without status' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'is invalid with a duplicate title' do
      FactoryBot.create(:task, title: 'duplicate title')
      task = FactoryBot.build(:task, title: 'duplicate title')
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
    end

    it 'is valid with another title'  do
      FactoryBot.create(:task, title: 'first title')
      task = FactoryBot.build(:task, title: 'second title')
      expect(task).to be_valid
    end
  end
end
