require "rails_helper"

RSpec.describe UsersController, type: :controller do
  before :each do
    @user = create(:user)
  end

  describe "Templates" do
    context "visit profile show page" do
      before do
        login_as(@user)
        get :show, id: 1
      end

      it { should render_template("show") }
      it { should render_with_layout("application") }
    end

    context "visit profile edit page" do
      before do
        login_as(@user)
        get :edit, id: 1
      end

      it { should render_template("edit") }
      it { should render_with_layout("application") }
    end

    context "visit profile edit page anonymously" do
      before do
        get :edit, id: 1
      end

      it { should redirect_to(login_url) }
    end

    context "visit profile new page" do
      before { get :new, id: 1 }

      it { should render_template("new") }
      it { should render_with_layout("application") }
    end
  end

  describe "Routing" do
    context "visit profile show page" do
      it do
        should route(:get, "/profile/1").to(action: :show, id: 1)
      end
    end

    context "edit a user profile" do
      it do
        should route(
          :get, "profile/1/edit").to(action: :edit, id: 1)
      end
    end

    context "update a user profile" do
      it do
        should route(
          :put, "profile/1").to(action: :update, id: 1)
      end
    end

    context "suspend a user profile" do
      it do
        should route(
          :delete, "profile/1").to(action: :destroy, id: 1)
      end
    end

    context "check username" do
      it do
        should route(
          :post, "users/check_username").
          to("users#check_username")
      end
    end

    context "check email" do
      it do
        should route(
          :post, "users/check_email").
          to("users#check_email")
      end
    end
  end

  describe "Validation" do
    context "validate email" do
      it do
        post :check_email, user: { email: "herbert.kagumba@example.com" },
                           format: :json

        should respond_with(200)

        expect(response.body).to eq "false"
      end
    end

    context "validate username" do
      it do
        post :check_username, user: { username: "habu" }, format: :json

        should respond_with(200)

        expect(response.body).to eq "false"
      end
    end
  end
end
