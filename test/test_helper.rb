ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# add for AcceptanceTest
require "simplecov"
require "capybara/rails"
require "fileutils"

SimpleCov.start "rails"


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end



class AcceptanceTest <ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FileUtils
  SCREENSHOTS_DIR = "screenshot"
  self.use_transactional_fixtures = false

  setup do
    Capybara.register_driver :selenium_firefox do |app|
      Capybara::Selenium::Driver.new(app, browser: :firefox)
    end
    Capybara.default_driver = :selenium_firefox

    Capybara.default_wait_time = 60
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    page.driver.browser.manage.window.maximize
  end


  teardown do
    DatabaseCleaner.clean
  end


  private
  # アプリケーションのrootであるURLからテストを開始するため
  def visit_root
    visit root_path
    ensure_browser_size
    assert_equal new_user_session_path, current_path
  end
  
  # スクリーンショットの取得
  # 撮ったスクリーンショットは変数SCREENSHOTS_DIRで指定されたフォルダに格納する
  def save_screenshot(fname)
    unless Capybara.default_driver == :rake_test
        mkdir_p SCREENSHOTS_DIR
        sleep 1
        super(File.join(SCREENSHOTS_DIR, fname))
    end
  end

  # サインアウト（ログアウト）を行う
  def sign_out
    click_link "Logout"
    assert_equal new_user_session_path, current_path
  end

  # ブラウザのサイズ調整（いい感じのサイズにしたいので）
  def ensure_browser_size(width = 600, height = 480)
    Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
  end

end