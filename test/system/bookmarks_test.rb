# frozen_string_literal: true

require 'application_system_test_case'

class BookmarksTest < ApplicationSystemTestCase
  setup do
    @report = reports(:report1)
    @question = questions(:question1)
  end

  test 'show my bookmark lists' do
    visit_with_auth '/current_user/bookmarks', 'komagata'
    assert_equal 'ブックマーク一覧 | FBC', title
    assert_text @report.title
  end

  test 'show my bookmark report' do
    visit_with_auth "/reports/#{@report.id}", 'komagata'
    assert_selector '#bookmark-button.is-active'
    assert_no_selector '#bookmark-button.is-inactive'
  end

  test 'show not bookmark report' do
    visit_with_auth "/reports/#{@report.id}", 'machida'
    assert_selector '#bookmark-button.is-inactive'
    assert_no_selector '#bookmark-button.is-active'
  end

  test 'bookmark' do
    visit_with_auth "/reports/#{@report.id}", 'machida'
    find('#bookmark-button').click
    assert_selector '#bookmark-button.is-active'
    assert_no_selector '#bookmark-button.is-inactive'

    visit '/current_user/bookmarks'
    assert_text @report.title
  end

  test 'unbookmark' do
    visit_with_auth "/reports/#{@report.id}", 'komagata'
    assert_selector '#bookmark-button.is-active'
    find('#bookmark-button').click
    assert_selector '#bookmark-button.is-inactive'
    assert_no_selector '#bookmark-button.is-active'

    visit '/current_user/bookmarks'
    assert_no_text @report.title
  end

  test 'show question bookmark on lists' do
    visit_with_auth '/current_user/bookmarks', 'kimura'
    assert_text @question.title
  end

  test 'show active button when bookmarked question' do
    visit_with_auth "/questions/#{@question.id}", 'kimura'
    assert_selector '#bookmark-button.is-active'
    assert_no_selector '#bookmark-button.is-inactive'
  end

  test 'show inactive button when not bookmarked question' do
    visit_with_auth "/questions/#{@question.id}", 'hajime'
    assert_selector '#bookmark-button.is-inactive'
    assert_no_selector '#bookmark-button.is-active'
  end

  test 'bookmark question' do
    visit_with_auth "/questions/#{@question.id}", 'hatsuno'
    find('#bookmark-button').click
    assert_selector '#bookmark-button.is-active'
    assert_no_selector '#bookmark-button.is-inactive'

    visit '/current_user/bookmarks'
    assert_text @question.title
  end

  test 'unbookmark question' do
    visit_with_auth "/questions/#{@question.id}", 'kimura'
    assert_selector '#bookmark-button.is-active'
    find('#bookmark-button').click
    assert_selector '#bookmark-button.is-inactive'
    assert_no_selector '#bookmark-button.is-active'

    visit '/current_user/bookmarks'
    assert_no_text @question.title
  end

  test 'edit bookmarks' do
    visit_with_auth current_user_bookmarks_path, 'kimura'
    assert_no_selector '.card-list-item__option'
    find(:css, '#spec-edit-mode').set(true)
    assert_selector '.card-list-item__option'
  end

  test 'delete bookmark from bookmarks' do
    visit_with_auth report_path(@report), 'komagata'
    assert_text 'Bookmark中'
    visit current_user_bookmarks_path
    assert_text 'komagata (Komagata Masaki) さんの相談部屋'
    find(:css, '#spec-edit-mode').set(true)
    assert_selector '.card-list-item__option'
    first('#bookmark-button').click
    assert_no_text 'komagata (Komagata Masaki) さんの相談部屋'
    visit report_path(@report)
    assert_text 'Bookmark'
  end
end
