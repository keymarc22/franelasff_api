# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      uid: response.headers["uid"],
      client: response.headers["client"],
      "access-token": response.headers["access-token"]
    }
  end

  before(:each) do
    post new_user_session_path, params: { email: user.email, password: user.password }, as: :json
    headers
  end

  describe "GET /users" do
    context "with data" do
      let!(:users) { create_list(:user, 20) }

      context "with user authenticated" do
        before { get api_v1_users_path, headers: headers }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should return users" do
          payload = JSON.parse(response.body)
          expect(payload.count).to eq(20)
        end
      end

      context "without authenticated user" do
        before { get api_v1_users_path }

        it "should return status code 401" do
          expect(response).to have_http_status(401)
        end
      end
    end

    context "without data" do
      before { get api_v1_users_path, headers: headers }

      it "should return status code 200" do
        payload = JSON.parse(response.body)

        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end

      it "should return users empty" do
        payload = JSON.parse(response.body)
        expect(payload.count).to eq(0)
      end
    end
  end

  describe "GET /users/{id}" do
    context "with valid id" do
      let!(:user) { create(:user) }

      context "with authenticated user" do
        before { get api_v1_user_path(id: user.id), headers: headers }

        it "should return status code 200" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(200)
        end

        it "should return user" do
          payload = JSON.parse(response.body)
          expect(payload["id"]).to eq(user.id)
          expect(payload["name"]).to eq(user.name)
          expect(payload["lastname"]).to eq(user.lastname)
          expect(payload["email"]).to eq(user.email)
          expect(payload["country"]).to eq(user.country)
          expect(payload["phone_number"]).to eq(user.phone_number)
        end
      end

      context "without user authenticated" do
        before { get api_v1_user_path(id: user.id) }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid id" do
      before { get api_v1_user_path(id: "100A"), headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        expect(payload["error"]).to eq("Couldn't find User with 'id'=100A")
      end
    end
  end

  describe "POST /users" do
    context "with valid data" do
      let!(:new_user) { attributes_for(:user) }

      context "with authenticated user" do
        before { post api_v1_users_path, params: { user: new_user }, headers: headers }

        it "should return status code 201" do
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(response).to have_http_status(:created)
          expect(response).to have_http_status(201)
        end

        it "should create user" do
          expect(User.count).to eq(2)
        end
      end

      context "without authenticated user" do
        before { post api_v1_users_path, params: { user: user } }

        it { expect(response).to have_http_status(401) }
      end
    end

    context "with invalid data" do
      let!(:new_user) { { color: "Testing" } }
      let!(:attributes) { attributes_for(:user, name: "") }
      before { post api_v1_users_path, params: { user: attributes }, headers: headers }

      it "should return status code 422" do
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(response).to have_http_status(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return error message" do
        payload = JSON.parse(response.body)
        msg = "La validación falló: el nombre no puede estar en blanco"
        expect(payload["error"]).to include(msg)
      end
    end
  end
end
