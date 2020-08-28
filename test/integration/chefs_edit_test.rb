require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
  @chef = Chef.create!(chefname: 'ruy', email:'ruy@example.com',
                       password: "password", password_confirmation:"password")
  @chef2 = Chef.create!(chefname: "john", email: "john@example.com",
                        password: "password", password_confirmation: "password")
  @admin_user = Chef.create!(chefname: "john", email: "john1@example.com",
                            password: "password", password_confirmation: "password", admin: true) 
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

  test "accept valid edit" do
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

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname: "ruyzito", email: "ruyzito@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "ruyzito", @chef.chefname
    assert_match "ruyzito@example.com", @chef.email
  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@example.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, 
                                  email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "ruy", @chef.chefname
    assert_match "ruy@example.com", @chef.email
  end
end
