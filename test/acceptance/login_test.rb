require 'test_helper'

class LoginTest <AcceptanceTest
  #fixtures :users
  
   # [正常系] 妥当なユーザ情報を入力してサインアップ -> サインアウト
  # users テーブルにレコードを追加して、メニュー画面に遷移することを確認
  test "sign up with valid user information and then sign out" do
    visit_root
    ensure_browser_size
    
    save_screenshot "scenario-01-01.png" 

    click_link "Sign up"
    save_screenshot "scenario-01-02.png"

      
    assert_difference "User.count" do
      fill_in "user_username", with: "YA900001"
      fill_in "user_email", with: "ya900001@test.org"
      fill_in "user_password", with: "passpass"
      fill_in "user_password_confirmation", with: "passpass"
      save_screenshot "scenario-01-03.png" 

      click_button "Sign up"
      save_screenshot "scenario-01-04.png" 

      # 適切な画面に遷移したかを確認
      assert_equal '/ideas', current_path
    end

    # ユーザーが登録されていることを確認
    new_user = User.find_by_username("YA900001")
    assert_not_nil new_user
    assert_equal "ya900001@test.org", new_user.email
    assert_not_nil new_user.last_sign_in_at

    sign_out
  end

# [異常系] ユーザ ID の桁が異なる入力しないでサインアップ
  test "username error01" do
    visit_root
    ensure_browser_size
    
    save_screenshot "scenario-02-01.png" 

    click_link "Sign up"
    save_screenshot "scenario-02-02.png" 

    
    assert_no_difference "User.count" do
      fill_in "user_username", with: "YA000"
      fill_in "user_email", with: "YA000@test.org"
      fill_in "user_password", with: "passpass"
      fill_in "user_password_confirmation", with: "passpass"
      save_screenshot "scenario-02-03.png" 

      click_button "Sign up"
      save_screenshot "scenario-02-04.png" 

      # 画面遷移せず（ログインしてしまったりせず）サインアップ画面に留まっていることを確認
      assert_equal user_registration_path, current_path
    end

  end


  # [異常系] ユーザ ID の桁は８桁だがすべて数字でサインアップ
  test "try to sign up without userid" do
    visit_root
    ensure_browser_size
    
      save_screenshot "scenario-03-01.png" 

    click_link "Sign up"
      save_screenshot "scenario-03-02.png" 

    assert_no_difference "User.count" do
      fill_in "user_username", with: "00000001"
      fill_in "user_email", with: "00000001@test.org"
      fill_in "user_password", with: "passpass"
      fill_in "user_password_confirmation", with: "passpass"
      save_screenshot "scenario-03-03.png" 

      click_button "Sign up"
      save_screenshot "scenario-03-04.png" 

      # 画面遷移せず（ログインしてしまったりせず）サインアップ画面に留まっていることを確認
      assert_equal user_registration_path, current_path
    end
  end

end
