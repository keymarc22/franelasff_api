# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Stores", type: :request do
  describe "GET /stores" do
    context "with data" do
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

    context "without data" do
      before { get stores_path }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return stores empty" do
        payload = JSON.parse(response.body)
        expect(payload["stores"].count).to eq(0)
      end
    end
  end

  describe "GET /stores/{id}" do
    context "with valid id" do
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

    context "with invalid id" do
      before { get store_path(id: "100A") }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to eq("Couldn't find Store with 'id'=100A")
      end
    end
  end

  describe "POST /stores" do
    context "with valid data" do
      let!(:store) { attributes_for(:store, owner_id: create(:user).id ) }
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

    context "with valid data" do
      let!(:store) { { name: "Testing" } }
      before { post stores_path, params: { store: store } }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to include("el usuario debe existir, la ubicación no puede estar en blanco")
      end
    end
  end

  describe "PUT /stores/{id}" do
    context "with valid data" do
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

    context "with invalid data" do
      let!(:store) { create(:store) }
      before { put store_path(id: store.id), params: { store: { name: "" } } }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)

        expect(payload["error"]).to eq("La validación falló: el nombre no puede estar en blanco")
      end
    end
  end

  describe "DELETE /stores/{id}" do
    context "with valid id" do
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

    context "with invalid id" do
      before { delete store_path(id: "100A") }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to eq("Couldn't find Store with 'id'=100A")
      end
    end
  end
end
