require "application_system_test_case"

class BuyerTest < ApplicationSystemTestCase

    setup do
        visit login_path
        fill_in 'email', with: 'buyer'
        fill_in 'password', with: 'password'
        click_button('Login')
    end

    test "Buyer Test Home" do
        assert_selector "h1", text: "Home"
    end

    test "Buyer Test Profile" do
        click_on('Profile')
        assert_selector "h1", text: "Profile"
        click_on('Back to home')
        assert_selector "h1", text: "Home"
    end

    test "Buyer Test My Market" do
        click_on('My Market')
        assert_selector "h1", text: "My Market"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Buyer Test Purchase History" do
        click_on('Purchase History')
        assert_selector "h1", text: "Purchase history"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Buyer Test logout" do
        click_on('Logout')
        assert_selector "p", text: "logout already!"
    end
end