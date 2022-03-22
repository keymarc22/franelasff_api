# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Stores", type: :request do

  describe "GET /stores" do
    let!(:stores) { create_list(:store, 20) }
    before { get stores_path }

    it "should return status code 200" do
      payload = JSON.parse(response.body)

      expect(payload).not_to be_empty
      expect(response).to have_http_status(200)
    end

    it "should return stores" do
      payload = JSON.parse(response.body)
      expect(payload["stores"].count).to eq(20)
    end
  end

  describe "GET /stores/{id}" do
    let!(:store) { create(:store) }
    before { get store_path(id: store.id) }

    it "should return status code 200" do
      payload = JSON.parse(response.body)

      expect(payload).not_to be_empty
      expect(response).to have_http_status(200)
    end

    it "should return store" do
      payload = JSON.parse(response.body)
      expect(payload["store"]["id"]).to eq(store.id)
    end
  end

  describe "POST /stores" do
    let!(:store) { attributes_for(:store) }
    before { post stores_path, params: { store: store } }

    it "should return status code 201" do
      payload = JSON.parse(response.body)

      expect(payload).not_to be_empty
      expect(response).to have_http_status(:created)
      expect(response).to have_http_status(201)
    end

    it "should create store" do
      expect(Store.count).to eq(1)
    end
  end

  describe "PUT /stores/{id}" do
    let!(:store) { create(:store) }
    let!(:attributes) { attributes_for(:store) }
    before { put store_path(id: store.id), params: { store: attributes } }

    it "should return status code 200" do
      payload = JSON.parse(response.body)

      expect(payload).not_to be_empty
      expect(response).to have_http_status(200)
    end

    it "should update store" do
      expect(store.reload.location).to eq(attributes[:location])
    end
  end

  describe "DELETE /stores/{id}" do
    let!(:store) { create(:store) }
    before { delete store_path(id: store.id) }

    it "should return status code 200" do
      payload = JSON.parse(response.body)

      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end

    it "should delete store" do
      expect(Store.count).to eq(0)
    end
  end
end
