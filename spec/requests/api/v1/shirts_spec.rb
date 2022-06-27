# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Shirts", type: :request do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      uid: response.headers["uid"],
      client: response.headers["client"],
      "access-token": response.headers["access-token"]
    }
  end

  before do
    post new_user_session_path, params: { email: user.email, password: user.password }, as: :json
    headers
  end

  describe "GET /shirts" do
    context "with data" do
      let!(:shirts) { create_list(:shirt, 20) }

      context "with user authenticated" do
        before { get api_v1_shirts_path, headers: headers }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should return shirts" do
          payload = JSON.parse(response.body)
          expect(payload.count).to eq(20)
        end
      end

      context "without authenticated user" do
        before { get api_v1_shirts_path }

        it "should return status code 401" do
          expect(response).to have_http_status(401)
        end
      end
    end

    context "without data" do
      before { get api_v1_shirts_path, headers: headers }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return shirts empty" do
        payload = JSON.parse(response.body)
        expect(payload.count).to eq(0)
      end
    end
  end

  describe "GET /shirts/{id}" do
    context "with valid id" do
      let!(:shirt) { create(:shirt) }

      context "with authenticated user" do
        before { get api_v1_shirt_path(id: shirt.id), headers: headers }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should return shirt" do
          payload = JSON.parse(response.body)
          expect(payload["id"]).to eq(shirt.id)
          expect(payload["color"]).to eq(shirt.color)
          expect(payload["size"]).to eq(shirt.size)
          expect(payload["print"]).to eq(shirt.print)
          expect(payload["quantity"]).to eq(shirt.quantity)
          expect(payload["owner"]["id"]).to eq(shirt.owner.id)
          expect(payload["store"]["id"]).to eq(shirt.store.id)
        end
      end

      context "without user authenticated" do
        before { get api_v1_shirt_path(id: shirt.id) }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid id" do
      before { get api_v1_shirt_path(id: "100A"), headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to eq("Couldn't find Shirt with 'id'=100A")
      end
    end
  end

  describe "POST /shirts" do
    context "with valid data" do
      context "with authenticated user" do
        let!(:shirt) { attributes_for(:shirt, store_id: create(:store).id) }

        before { post api_v1_shirts_path, params: { shirt: shirt }, headers: headers }

        it "should return status code 201" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(:created)
          expect(response).to have_http_status(201)
        end

        it "should create shirt" do
          expect(Shirt.count).to eq(1)
        end
      end

      context "without authenticated user" do
        let!(:shirt) { attributes_for(:shirt, store_id: create(:store).id) }
        before { post api_v1_shirts_path, params: { shirt: shirt } }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid data" do
      let!(:shirt) { { color: "Testing" } }
      let!(:attributes) { attributes_for(:shirt, color: "") }
      before { post api_v1_shirts_path, params: { shirt: attributes }, headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        msg = "La validación falló: el almacén debe existir, el color no puede estar en blanco"
        expect(payload["error"]).to include(msg)
      end
    end
  end

  describe "PUT /shirts/{id}" do
    context "with valid data" do
      context "with authenticated user" do
        let!(:shirt) { create(:shirt) }
        let!(:attributes) { attributes_for(:shirt) }

        before { put api_v1_shirt_path(id: shirt.id), params: { shirt: attributes }, headers: headers }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should update shirt" do
          expect(shirt.reload.color).to eq(attributes[:color])
        end
      end

      context "without authenticated user" do
        let!(:shirt) { create(:shirt) }
        let!(:attributes) { attributes_for(:shirt) }
        before { put api_v1_shirt_path(id: shirt.id), params: { shirt: attributes } }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid data" do
      let!(:shirt) { create(:shirt) }
      let!(:attributes) { attributes_for(:shirt, color: "") }
      before { put api_v1_shirt_path(id: shirt.id), params: { shirt: attributes }, headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)

        expect(payload["error"]).to eq("La validación falló: el color no puede estar en blanco")
      end
    end
  end

  describe "DELETE /shirts/{id}" do
    context "with valid id" do
      context "with authenticated user" do
        let!(:shirt) { create(:shirt) }

        before { delete api_v1_shirt_path(id: shirt.id), headers: headers }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).to be_empty
          expect(response).to have_http_status(200)
        end

        it "should delete shirt" do
          expect(Shirt.count).to eq(0)
        end
      end

      context "without authenticated user" do
        let!(:shirt) { create(:shirt) }
        before { delete api_v1_shirt_path(id: shirt.id) }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid id" do
      before { delete api_v1_shirt_path(id: "100A"), headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to eq("Couldn't find Shirt with 'id'=100A")
      end
    end
  end
end
