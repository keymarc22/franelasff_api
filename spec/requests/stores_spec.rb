# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Stores", type: :request do
  let!(:user) { create(:user) }
  let!(:header) { { authorization: "Bearer #{user.auth_token}" } }

  describe "GET /stores" do
    context "with data" do
      context "with authenticated user" do
        let!(:stores) { create_list(:store, 20) }
        before { get stores_path, headers: header }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should return stores" do
          payload = JSON.parse(response.body)
          expect(payload.count).to eq(20)
        end
      end

      context "without authenticated user" do
        let!(:stores) { create_list(:store, 20) }
        before { get stores_path }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "without data" do
      before { get stores_path, headers: header }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return stores empty" do
        payload = JSON.parse(response.body)
        expect(payload.count).to eq(0)
      end
    end
  end

  describe "GET /stores/{id}" do
    context "with valid id" do
      context "with authenticated user" do
        let!(:store) { create(:store) }
        before { get store_path(id: store.id), headers: header }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should return store" do
          payload = JSON.parse(response.body)
          expect(payload["id"]).to eq(store.id)
        end

        it "should return information" do
          payload = JSON.parse(response.body)

          expect(payload["id"]).to eq(store.id)
          expect(payload["name"]).to eq(store.name)
          expect(payload["location"]).to eq(store.location)
          expect(payload["shirts"]).to eq(store.shirts)
        end
      end

      context "without authenticated user" do
        let!(:store) { create(:store) }
        before { get store_path(id: store.id) }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid id" do
      before { get store_path(id: "100A"), headers: header }

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
      context "with authenticated user" do
        let!(:store) { attributes_for(:store, owner_id: create(:user).id) }
        before { post stores_path, params: { store: store }, headers: header }

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

      context 'without authenticated user' do
        let!(:store) { attributes_for(:store, owner_id: create(:user).id) }
        before { post stores_path, params: { store: store } }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with valid data" do
      let!(:store) { { name: "Testing" } }
      before { post stores_path, params: { store: store }, headers: header }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to include("la ubicación no puede estar en blanco")
      end
    end
  end

  describe "PUT /stores/{id}" do
    context "with valid data" do
      context "with authenticated user" do
        let!(:store) { create(:store) }
        let!(:attributes) { attributes_for(:store) }
        before { put store_path(id: store.id), params: { store: attributes }, headers: header }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should update store" do
          expect(store.reload.location).to eq(attributes[:location])
        end
      end

      context "without authenticated user" do
        let!(:store) { create(:store) }
        let!(:attributes) { attributes_for(:store) }
        before { put store_path(id: store.id), params: { store: attributes } }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid data" do
      let!(:store) { create(:store) }
      before { put store_path(id: store.id), params: { store: { name: "" } }, headers: header }

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
      context "with authenticated user" do
        let!(:store) { create(:store) }
        before { delete store_path(id: store.id), headers: header }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).to be_empty
          expect(response).to have_http_status(200)
        end

        it "should delete store" do
          expect(Store.count).to eq(0)
        end
      end

      context "without authenticated user" do
        let!(:store) { create(:store) }
        before { delete store_path(id: store.id) }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid id" do
      before { delete store_path(id: "100A"), headers: header }

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
