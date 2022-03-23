# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Catalogues", type: :request do
  describe "GET /catalogues" do
    context "with data" do
      let!(:catalogues) { create_list(:catalogue, 20) }
      before { get catalogues_path }

      it "should return status code 200" do
        payload = JSON.parse(response.body)
        expect(payload).not_to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return catalogues" do
        payload = JSON.parse(response.body)
        expect(payload["catalogues"].count).to eq(20)
      end
    end

    context "without data" do
      before { get catalogues_path }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return catalogues empty" do
        payload = JSON.parse(response.body)
        expect(payload["catalogues"].count).to eq(0)
      end
    end
  end

  describe "GET /catalogues/{id}" do
    context "with valid id" do
      let!(:catalogue) { create(:catalogue) }
      before { get catalogue_path(id: catalogue.id) }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return catalogue" do
        payload = JSON.parse(response.body)
        expect(payload["catalogue"]["id"]).to eq(catalogue.id)
      end
    end

    context "with invalid id" do
      before { get catalogue_path(id: "100A") }

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

  describe "POST /catalogues" do
    context "with valid data" do
      let!(:catalogue) { attributes_for(:catalogue, store_id: create(:store).id, owner_id: create(:user).id) }
      before { post catalogues_path, params: { catalogue: catalogue } }

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

    context "with valid data" do
      let!(:catalogue) { { color: "Testing" } }
      let!(:attributes) { attributes_for(:catalogue, title: "") }
      before { post catalogues_path, params: { catalogue: attributes } }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        msg = "La validación falló: el usuario debe existir, el título no puede estar en blanco"
        expect(payload["error"]).to include(msg)
      end
    end
  end

  describe "PUT /catalogues/{id}" do
    context "with valid data" do
      let!(:catalogue) { create(:catalogue) }
      let!(:attributes) { attributes_for(:catalogue) }
      before { put catalogue_path(id: catalogue.id), params: { catalogue: attributes } }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(200)
      end

      it "should update catalogue" do
        expect(catalogue.reload.title).to eq(attributes[:title])
      end
    end

    context "with invalid data" do
      let!(:catalogue) { create(:catalogue) }
      let!(:attributes) { attributes_for(:catalogue, title: "") }
      before { put catalogue_path(id: catalogue.id), params: { catalogue: attributes } }

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
      before { delete catalogue_path(id: catalogue.id) }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end

      it "should delete catalogue" do
        expect(Catalogue.count).to eq(0)
      end
    end

    context "with invalid id" do
      before { delete catalogue_path(id: "100A") }

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
