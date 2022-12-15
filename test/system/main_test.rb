require "application_system_test_case"

class MainTest < ApplicationSystemTestCase
    test "visit home" do
        visit main_url
        assert_selector "h1", text: "Home"
    end
end