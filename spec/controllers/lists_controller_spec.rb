require "rails_helper"

RSpec.describe ListsController, type: :controller do
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:list)
  end

  context "not logged in" do
    describe "GET #index" do
      it "should redirect to login" do
        expect(get(:index)).to redirect_to(new_user_session_url)
      end
    end

    describe "GET #show" do
      list = FactoryGirl.create(:list)
      it "should redirect to login" do
        expect(get(:show, id: list.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "GET #new" do
      it "should redirect to login" do
        expect(get(:new)).to redirect_to(new_user_session_url)
      end
    end

    describe "GET #edit" do
      it "should redirect to login" do
        list = FactoryGirl.create(:list)
        expect(get(:edit, id: list.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "POST #create" do
      it "should redirect to login" do
        expect(post(:create, list: valid_attributes)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "PUT #update" do
      it "should redirect to login" do
        list = FactoryGirl.create(:list)
        expect(put(:update, id: list.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "DELETE #destroy" do
      it "should redirect to login" do
        list = FactoryGirl.create(:list)
        expect(delete(:destroy, id: list.to_param)).
          to redirect_to(new_user_session_url)
      end
    end
  end

  context "logged in" do
    login_user

    describe "GET #index" do
      it "assigns user lists as @lists" do
        user_list = FactoryGirl.create(:list, user: @current_user)
        FactoryGirl.create(:list)
        get :index
        expect(assigns(:lists)).to contain_exactly(user_list)
      end
    end

    describe "GET #show" do
      it "should not find non-user lists" do
        list = FactoryGirl.create(:list)
        expect { get(:show, id: list.to_param) }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "assigns user list as @list" do
        list = FactoryGirl.create(:list, user: @current_user)
        get(:show, id: list.to_param)
        expect(assigns(:list)).to eq(list)
      end
    end

    describe "GET #new" do
      it "assigns a new list as @list" do
        get :new
        expect(assigns(:list)).to be_a_new(List)
      end
    end

    describe "GET #edit" do
      it "cannot find non user lists" do
        list = FactoryGirl.create(:list)
        expect { get :edit, id: list.to_param }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "assigns the requested list as @list" do
        list = FactoryGirl.create(:list, user: @current_user)
        get :edit, id: list.to_param
        expect(assigns(:list)).to eq(list)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new List" do
          expect do
            post :create, list: valid_attributes
          end.to change(List, :count).by(1)
        end

        it "assigns a newly created user list as @list" do
          post :create, list: valid_attributes
          expect(assigns(:list)).to be_a(List)
          expect(assigns(:list)).to be_persisted
          expect(assigns(:list).user).to eq(@current_user)
        end

        it "redirects to the created list" do
          post :create, list: valid_attributes
          expect(response).to redirect_to(list_url(List.last))
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved list as @list" do
          post :create, list: { list_id: nil }
          expect(assigns(:list)).to be_a_new(List)
        end

        it "re-renders the 'new' template" do
          post :create, list: { list_id: nil }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { name: "New Name" } }

        it "cannot find non user lists" do
          list = FactoryGirl.create(:list)
          expect { put :update, id: list.to_param }.
            to raise_error(ActiveRecord::RecordNotFound)
        end

        it "updates the requested list" do
          list = FactoryGirl.create(:list, user: @current_user)
          put :update, id: list.to_param, list: new_attributes
          expect(list.reload.name).to eq("New Name")
        end

        it "assigns the requested list as @list" do
          list = FactoryGirl.create(:list, user: @current_user)
          put :update, id: list.to_param, list: new_attributes
          expect(assigns(:list)).to eq(list)
        end

        it "redirects to the list" do
          list = FactoryGirl.create(:list, user: @current_user)
          put :update, id: list.to_param, list: valid_attributes
          expect(response).to redirect_to(list_url(list))
        end
      end

      context "with invalid params" do
        it "assigns the list as @list" do
          list = FactoryGirl.create(:list, user: @current_user)
          put :update, id: list.to_param, list: { name: nil }
          expect(assigns(:list)).to eq(list)
        end

        it "re-renders the 'edit' template" do
          list = FactoryGirl.create(:list, user: @current_user)
          put :update, id: list.to_param, list: { name: nil }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "cannot find non user lists" do
        list = FactoryGirl.create(:list)
        expect { delete :destroy, id: list.to_param }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroys the requested list" do
        list = FactoryGirl.create(:list, user: @current_user)
        expect do
          delete :destroy, id: list.to_param
        end.to change(List, :count).by(-1)
      end

      it "redirects to the lists list" do
        list = FactoryGirl.create(:list, user: @current_user)
        delete :destroy, id: list.to_param
        expect(response).to redirect_to(lists_url)
      end
    end
  end
end
