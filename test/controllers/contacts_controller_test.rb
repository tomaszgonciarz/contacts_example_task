require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact = contacts(:one)
    @contact.email = "e#{SecureRandom.alphanumeric(8)}@example.com"
  end

  test "should get index" do
    get contacts_url, as: :json
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post contacts_url, params: { contact: { email: @contact.email, name: @contact.name } }, as: :json
    end

    assert_response 201
  end

  test "should create many contacts" do
    time = Time.now.to_i
    p "Start at: #{time}"
    assert_difference('Contact.count', 10000) do
      post mass_create_contacts_url, as: :json
    end

    now = Time.now.to_i
    p "End at: #{now}"
    p "Delta: #{now - time} seconds"
    assert_response 201
  end

  test "should show contact" do
    get contact_url(@contact), as: :json
    assert_response :success
  end

  test "should update contact" do
    patch contact_url(@contact), params: { contact: { email: @contact.email, name: @contact.name } }, as: :json
    assert_response 200
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete contact_url(@contact), as: :json
    end

    assert_response 204
  end
end
