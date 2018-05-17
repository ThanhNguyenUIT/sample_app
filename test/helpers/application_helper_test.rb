require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title(""), t("layouts.application.base_title")
    assert_equal full_title(t "static_pages.help.title"), t("static_pages.help.title") + " | " + t("layouts.application.base_title")
  end
end
