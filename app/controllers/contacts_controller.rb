# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update, :destroy]

  # GET /contacts
  def index
    @contacts = Contact.all

    render json: @contacts
  end

  # GET /contacts/1
  def show
    render json: @contact
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render json: @contact, status: :created, location: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # POST /mass_create
  def mass_create
    contact_attrs = params[:contact_attrs] || GenerateContacts.new.call

    contacts = []

    contact_attrs.each do |attrs|
      contact = Contact.new(attrs)
      contact.save!
      contacts << {id: contact.id, name: contact.name, email: contact.email}
    end

    render json: contacts, status: :created
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(:name, :email, :first_name, :last_name, addresses_attributes: [:city, :street, :house_number])
    end
end
