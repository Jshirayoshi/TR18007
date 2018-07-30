require 'test_helper'

class MakersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get makers_index_url
    assert_response :success
  end

  test "should get calc" do
    get makers_calc_url
    assert_response :success
  end

  test "should get res" do
    get makers_res_url
    assert_response :success
  end

end
