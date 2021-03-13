require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let!(:user){ create(:user) }
  let!(:other_user){ create(:user) }
  let!(:task){ create(:task,user: user) }

  describe 'ログイン前' do
    describe 'タスクの新規作成画面' do
      it 'タスクの新規作成に失敗する'do
        visit  new_task_path
        expect(current_path).to eq login_path
        expect(page).to have_content "Login required"
      end
    end
    describe 'タスクの編集画面' do
      it 'タスクの新規作成に失敗する' do
        visit  edit_task_path(user)
        expect(current_path).to eq login_path
        expect(page).to have_content "Login required"
      end
    end
  end
  describe 'ログイン後' do
    before { sign_in_as(user) }
    describe 'タスクの新規作成画面' do
      context 'フォームの入力値が正常' do
        it 'タスクの新期作成に成功する' do
          visit user_path(user)
          click_link "New task"
          expect(current_path).to eq new_task_path
          fill_in "Title", with: "test title"
          fill_in "Content", with: "test content"
          select "todo", from: "Status" 
          fill_in "Deadline", with: 1.week.from_now
          click_button "Create Task"
          expect(current_path).to eq task_path(2)
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'test content'
        end
      end
    end
    describe 'タスクの編集画面' do
      context 'フォームの入力値が正常' do
        it '編集が成功する' do
          visit edit_task_path(task)
          fill_in "Title", with: "Edited_Title_1"
          click_button "Update Task"
          expect(current_path).to eq task_path(task)
          expect(page).to have_content 'Task was successfully updated.'
          expect(page).to have_content 'Edited_Title_1'
        end
      end
    end
    describe 'タスクを削除' do
      it 'タスクの削除に成功する' do
        visit root_path
        click_link "Destroy"
        expect{task.destroy}.to change{ Task.count }.by (-1)
        #expect(page).not_to have_content "title_1"
      end
    end
  end
end
