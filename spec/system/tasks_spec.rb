require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user){ create(:user) }
  let(:other_user){ create(:user) }
  let(:task){ create(:task) }

  describe 'ログイン前' do
    context 'タスクの新規作成画面にアクセス' do
      it 'タスクの新規作成に失敗する'do
        visit  new_task_path
        expect(current_path).to eq login_path
        expect(page).to have_content "Login required"
      end
    end
    context 'タスクの編集画面にアクセス' do
      it 'タスクの新規作成に失敗する' do
        visit  edit_task_path(task)
        expect(current_path).to eq login_path
        expect(page).to have_content "Login required"
      end
    end
    context 'タスクの詳細ページにアクセス' do
      it 'タスクの詳細情報が表示される' do
        visit task_path(task)
        expect(page).to have_content task.title
        expect(current_path).to eq task_path(task)
      end
    end
    context 'タスクの一覧ページにアクセス' do
      it 'すべてのユーザーのタスク情報が表示される' do
        task_list = create_list(:task, 3)
        visit tasks_path
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[2].title
        expect(current_path).to eq tasks_path
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
          fill_in "Title", with: "test title"
          fill_in "Content", with: "test content"
          select "todo", from: "Status" 
          fill_in "Deadline", with: 1.week.from_now
          click_button "Create Task"
          #let(:task)は遅延評価のため、ここでは呼び出されていない。なので、ここで作成したtaskのidは１
          expect(current_path).to eq '/tasks/1'
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'test content'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'test_content'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          #DBに登録済みのtaskを作成&ローカル変数に代入
          other_task = create(:task)
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'test_content'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq tasks_path
        end
      end

    end
    describe 'タスクの編集画面' do
      #編集とは既存のデータを編集すること。なので既にあるデータを用意する必要がある。
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      #タスク編集画面への遷移を事前に行っておく。
      before { visit edit_task_path(task) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          fill_in 'Title', with: 'updated_title'
          select :done, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content 'Title: updated_title'
          expect(page).to have_content 'Status: done'
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq task_path(task)
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: other_task.title
          select :todo, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: nil
          select :todo, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: other_task.title
          select :todo, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスクを削除' do
      let!(:task) { create(:task, user: user) }

      it 'タスクの削除が成功する' do
        visit tasks_path
        click_link 'Destroy'
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(page).to have_content 'Task was successfully destroyed'
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
  end
end
