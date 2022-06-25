# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Catalogues", type: :request do
  let!(:user) { create(:user) }
  let(:store) { create(:store) }
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

  describe "GET /catalogues" do
    context "with data" do
      let!(:catalogues) { create_list(:catalogue, 20) }
      before { get api_v1_catalogues_path, headers: headers }

      it "should return status code 200" do
        payload = JSON.parse(response.body)
        expect(payload).not_to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return catalogues" do
        payload = JSON.parse(response.body)
        expect(payload.count).to eq(20)
      end
    end

    context "without data" do
      before { get api_v1_catalogues_path, headers: headers }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return catalogues empty" do
        payload = JSON.parse(response.body)
        expect(payload.count).to eq(0)
      end
    end

    context "without authentication" do
      before { get api_v1_catalogues_path }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return catalogues empty" do
        payload = JSON.parse(response.body)
        expect(payload.count).to eq(0)
      end
    end
  end

  describe "GET /catalogues/{id}" do
    context "with valid id" do
      let!(:catalogue) { create(:catalogue) }
      before { get api_v1_catalogue_path(id: catalogue.id), headers: headers }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return catalogue" do
        payload = JSON.parse(response.body)
        expect(payload["id"]).to eq(catalogue.id)
        expect(payload["title"]).to eq(catalogue.title)
        expect(payload["description"]).to eq(catalogue.description)
        expect(payload["shirts"]).to eq(catalogue.shirts)
      end
    end

    context "with invalid id" do
      before { get api_v1_catalogue_path(id: "100A"), headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to eq("Couldn't find Catalogue with 'id'=100A")
      end
    end

    context "without authentication" do
      let!(:catalogue) { create(:catalogue) }
      before { get api_v1_catalogue_path(id: catalogue.id) }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return catalogue" do
        payload = JSON.parse(response.body)
        expect(payload["id"]).to eq(catalogue.id)
        expect(payload["title"]).to eq(catalogue.title)
        expect(payload["description"]).to eq(catalogue.description)
        expect(payload["shirts"]).to eq(catalogue.shirts)
      end
    end
  end

  describe "POST /catalogues" do
    context "with valid data" do
      let!(:catalogue) { attributes_for(:catalogue, store: store) }

      context "with user authenticated" do
        before do
          post api_v1_catalogues_path, params: { catalogue: catalogue }, headers: headers
        end

        it "should return status code 201" do
          payload = JSON.parse(response.body)
          expect(payload).not_to be_empty
          expect(response).to have_http_status(:created)
          expect(response).to have_http_status(201)
        end

        it "should create catalogue" do
          expect(Catalogue.count).to eq(1)
        end
      end

      context "without user authenticated" do
        before { post api_v1_catalogues_path, params: { catalogue: catalogue } }

        it "should return status code 401" do
          expect(response).to have_http_status(:unauthorized)
          expect(response).to have_http_status(401)
        end

        it "should not create catalogue" do
          expect(Catalogue.count).to eq(0)
        end
      end
    end

    context "without valid data" do
      let!(:catalogue) { attributes_for(:catalogue, title: "", store: store) }
      before { post api_v1_catalogues_path, params: { catalogue: catalogue }, headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        msg = "La validación falló: el título no puede estar en blanco"
        expect(payload["error"]).to include(msg)
      end
    end
  end

  describe "PUT /catalogues/{id}" do
    let!(:catalogue) { create(:catalogue) }
    let!(:attributes) { attributes_for(:catalogue) }

    context "with valid data" do
      context "with user authenticated" do
        before { put api_v1_catalogue_path(id: catalogue.id), params: { catalogue: attributes }, headers: headers }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should update catalogue" do
          expect(catalogue.reload.title).to eq(attributes[:title])
        end
      end

      context "without user authenticated" do
        before { put api_v1_catalogue_path(id: catalogue.id), params: { catalogue: attributes } }

        it "should return status code 401" do
          expect(response).to have_http_status(:unauthorized)
          expect(response).to have_http_status(401)
        end

        it "should update catalogue" do
          expect(catalogue.title).to_not eq(attributes[:title])
        end
      end
    end

    context "with invalid data" do
      let!(:catalogue) { create(:catalogue) }
      let!(:attributes) { attributes_for(:catalogue, title: "") }
      before { put api_v1_catalogue_path(id: catalogue.id), params: { catalogue: attributes }, headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)

        expect(payload["error"]).to eq("La validación falló: el título no puede estar en blanco")
      end
    end
  end

  describe "DELETE /catalogues/{id}" do
    context "with valid id" do
      let!(:catalogue) { create(:catalogue) }

      context "with user authenticated" do
        before { delete api_v1_catalogue_path(id: catalogue.id), headers: headers }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).to be_empty
          expect(response).to have_http_status(200)
        end

        it "should delete catalogue" do
          expect(Catalogue.count).to eq(0)
        end
      end

      context "without user authenticated" do
        before { delete api_v1_catalogue_path(id: catalogue.id) }

        it "should return status code 401" do
          expect(response).to have_http_status(401)
        end

        it "should not delete catalogue" do
          expect(Catalogue.count).to eq(1)
        end
      end
    end

    context "with invalid id" do
      before { delete api_v1_catalogue_path(id: "100A"), headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to eq("Couldn't find Catalogue with 'id'=100A")
      end
    end
  end
end
