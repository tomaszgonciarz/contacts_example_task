require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact = contacts(:one)
    @contact.email = "e#{SecureRandom.alphanumeric(8)}@example.com"
  end

  test "#index" do
    get contacts_url, as: :json
    assert_response :success
  end

  test "#create" do
    assert_difference('Address.count', 2) do
      assert_difference('Contact.count') do
        post contacts_url, params: { contact: { email: @contact.email,
                                                name: @contact.name,
                                                first_name: @contact.first_name,
                                                last_name: @contact.last_name,
                                                addresses_attributes: [
                                                  { city: 'Warsaw',
                                                  street: 'Wall Street',
                                                  house_number: 1 },
                                                  { city: 'Warsaw',
                                                  street: 'Baker Street',
                                                  house_number: 2 } ] } },
                           as: :json
      end
    end

    assert_response 201

    body = JSON.parse(response.body)
    assert_equal('First name one', body['first_name'])
    assert_equal('Last name one', body['last_name'])
  end

  test "#mass_create" do
    time = Time.now.to_i
    p "Start at: #{time}"
    assert_difference('Contact.count', 10000) do
      post mass_create_contacts_url, as: :json
    end

    now = Time.now.to_i
    p "End at: #{now}"
    p "Delta: #{now - time} seconds"
    assert_response 201

    body = JSON.parse(response.body).first
    assert_not_nil(body['id'])
    assert_not_nil(body['name'])
    assert_not_nil(body['email'])
  end

  test "#mass_create error" do
    assert_no_difference'Contact.count' do
      post mass_create_contacts_url, params: { contact_attrs: [ { name: 'name', email: 'email' }, { name: nil, email: 'email2' }] }, as: :json
    end

    assert_response 422
    assert_equal('Invalid arguments!', JSON.parse(response.body)['error'])
  end

  test "#show" do
    get contact_url(@contact), as: :json
    assert_response :success
  end

  test "#update" do
    patch contact_url(@contact), params: { contact: { email: @contact.email, name: @contact.name } }, as: :json
    assert_response 200
  end

  test "#destroy" do
    assert_difference('Contact.count', -1) do
      delete contact_url(@contact), as: :json
    end

    assert_response 204
  end
end
