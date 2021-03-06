require 'test_helper'

class ChefTest < ActiveSupport::TestCase
    def setup
        @chef = Chef.new(chefname: 'ruy', email: 'ruy@example.com',
                        password: "password", password_confirmation:"password")
    end
    
    test 'chef should be valid' do
        assert @chef.valid?
    end

    test 'name should be presente' do
        @chef.chefname=' '
        assert_not @chef.valid? 
    end

    test 'name shoud be less than 30 character' do
        @chef.chefname = 'a'*31
        assert_not @chef.valid?
    end

    test 'email should be present' do
        @chef.email= ' '
        assert_not @chef.valid?
    end

    test 'email format should be valid' do
        valid_emails = %w[user@example.com RUY@gmail.com r.melo@yahoo.ca ruyzera@co.uk.org]
        valid_emails.each do |valids|
            @chef.email = valids
            assert @chef.valid?, '#{valids.inspect} should be valid'
        end
    end

    test "should reject invalid addresses" do
        invalid_emails = %w[mashrur@example mashrur@example,com mashrur.name@gmail. joe@bar+foo.com]
        invalid_emails.each do |invalids|
            @chef.email = invalids
            assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
        end
    end 

    test "email should be unique and case insensitive" do
        duplicate_chef = @chef.dup
        duplicate_chef.email = @chef.email.upcase
        @chef.save
        assert_not duplicate_chef.valid?
    end

    test "email should be lower case before hitting db" do
        mixed_email = "JohN@ExampLe.com"
        @chef.email = mixed_email
        @chef.save
        assert_equal mixed_email.downcase, @chef.reload.email 
    end

    test "password should be presente" do
        @chef.password = @chef.password_confirmation = " "
        assert_not @chef.valid?
    end

    test "password should be at least 5 characters" do
        @chef.password = @chef.password_confirmation = "a"*4
        assert_not @chef.valid?
    end
    test "associated recipes should be destroyed" do
        @chef.save
        @chef.recipes.create!(name: "testing delete", description: "testing delete function")
        assert_difference 'Recipe.count', -1 do
          @chef.destroy
        end
    end
end