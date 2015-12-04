require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:example)
  end

=begin 
  def redirect_back_or_default(default)
  	http://stackoverflow.com/questions/9489660/return-user-to-previous-page-after-login-rails
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
end
=end 
  test 'Unsuccessful edit' do
  	log_in_as(@user, {})
  	get edit_user_path(@user)
  	assert_template 'users/edit'
  	patch user_path(@user), user: { name: "", email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
  	assert_template 'users/edit'
    assert_select 'div#error_explanation'
   	assert_select 'div.field_with_errors'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
   	name = "Example"
  	email = "foo@example.com"
  	patch user_path(@user), user: { name: name, email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    assert_nil session[:forwarding_url]
     
  end
end 
