require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }
  let(:auth) { UserAuthenticator.new(user) }

  describe "Sessions pages" do
    context "When I visit the login page" do
      before do
        get :new
      end

      it { should render_template "new" }
      it { should render_with_layout "application" }
    end

    context "When I logout a user" do
      before do
        delete :destroy
      end

      it { should redirect_to login_path }
      it { should_not set_session[:user_id] }
    end

    context "When a user successfully logs in" do
      before do
        post :create,
             session: {
               email_username: user.email,
               password: user.password
             }
      end

      it { should set_session[:user_id] }
      it "can remember a user using remember_token" do
        auth.remember_user(user)
        expect(auth.authenticated?(user.remember_token)).to be true
      end

      it "the remember_digest is updated on remember" do
        auth.remember_user(user)
        expect(user.remember_digest).not_to be_nil
      end
    end

    context "When a user fails to log in" do
      before do
        post :create,
             session: {
               email_username: Faker::Internet.email,
               password: Faker::Internet.password
             }
      end

      it { should_not set_session[:user_id] }
      it "renders the login page" do
        expect(response).to render_template :new
      end
    end

    context "When a user tries to login using their email" do
      before do
        post :check_username_email,
             session: { email_username: user.email },
             format: :json
      end

      it "checks if user exists" do
        expect(response.body).to eq "true"
      end
    end

    context "When a user tries to login using their username" do
      before do
        post :check_username_email,
             session: { email_username: user.username },
             format: :json
      end

      it "checks if user exists" do
        expect(response.body).to eq "true"
      end
    end
  end
end
