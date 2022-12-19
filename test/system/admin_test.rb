require "application_system_test_case"

class AdminTest < ApplicationSystemTestCase

    setup do
        visit login_path
        fill_in 'email', with: 'admin'
        fill_in 'password', with: 'password'
        click_button('Login')
    end

    test "Admin Test Home" do
        assert_selector "h1", text: "Home"
    end

    test "Admin Test Profile" do
        click_on('Profile')
        assert_selector "h1", text: "Profile"
        click_on('Back to home')
        assert_selector "h1", text: "Home"
    end

    test "Admin Test My Inventories" do
        click_on('My Inventory')
        assert_selector "h1", text: "My inventory"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Admin Test Top Seller" do
        click_on('Top Seller')
        assert_selector "h3", text: "Top Seller"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Admin Test Sale History" do
        click_on('Sale History')
        assert_selector "h1", text: "Sale history"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Admin Test My Market" do
        click_on('My Market')
        assert_selector "h1", text: "My Market"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Admin Test Purchase History" do
        click_on('Purchase History')
        assert_selector "h1", text: "Purchase history"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Admin Test Add Items" do
        click_on('Add Items')
        assert_selector "h1", text: "Items"
        click_on('Back to home')
        assert_selector "h1", text: "Home"
    end

    test "Admin Test logout" do
        click_on('Logout')
        assert_selector "p", text: "logout already!"
    end
end