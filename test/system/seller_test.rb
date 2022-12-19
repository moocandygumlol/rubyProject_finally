require "application_system_test_case"

class SellerTest < ApplicationSystemTestCase

    setup do
        visit login_path
        fill_in 'email', with: 'seller'
        fill_in 'password', with: 'password'
        click_button('Login')
    end
    
    test "Seller Test Home" do
        assert_selector "h1", text: "Home"
    end

    test "Seller Test Profile" do
        click_on('Profile')
        assert_selector "h1", text: "Profile"
        click_on('Back to home')
        assert_selector "h1", text: "Home"
    end

    test "Seller Test My Inventories" do
        click_on('My Inventory')
        assert_selector "h1", text: "My inventory"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Seller Test Top Seller" do
        click_on('Top Seller')
        assert_selector "h3", text: "Top Seller"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Seller Test Sale History" do
        click_on('Sale History')
        assert_selector "h1", text: "Sale history"
        click_on('back to main')
        assert_selector "h1", text: "Home"
    end

    test "Seller Test logout" do
        click_on('Logout')
        assert_selector "p", text: "logout already!"
    end

end