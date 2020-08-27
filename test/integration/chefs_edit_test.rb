require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
  @chef = Chef.create!(chefname: 'ruy', email:'ruy@example.com',
                       password: "password", password_confirmation:"password")
  end

  test "reject invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname: " ", email: "ruy@example.com"}}
    assert_template 'chefs/edit'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end

  test "accept valid signup" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname: "ruyzin", email: "ruyzin@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "ruyzin", @chef.chefname
    assert_match "ruyzin@example.com", @chef.email
  end

end
