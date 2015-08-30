require "rails_helper"

RSpec.describe ListItemsController, type: :controller do
  let(:list) do
    FactoryGirl.create(:list,
                       user: @current_user || FactoryGirl.create(:user))
  end
  let(:food) do
    FactoryGirl.create(:food, user: @current_user || FactoryGirl.create(:user))
  end
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:list_item,
                               list_id: list.id,
                               food_id: food.id)
  end

  context "not logged in" do
    describe "GET #new" do
      it "should redirect to login" do
        expect(get(:new, list_id: list.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "GET #edit" do
      it "should redirect to login" do
        list_item = FactoryGirl.create(:list_item)
        expect(get(:edit, list_id: list.to_param, id: list_item.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "POST #create" do
      it "should redirect to login" do
        expect(post(:create,
                    list_id: list.to_param,
                    list_item: valid_attributes)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "PUT #update" do
      it "should redirect to login" do
        list_item = FactoryGirl.create(:list_item)
        expect(put(:update,
                   list_id: list.to_param,
                   id: list_item.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "DELETE #destroy" do
      it "should redirect to login" do
        list_item = FactoryGirl.create(:list_item)
        expect(delete(:destroy,
                      list_id: list.to_param,
                      id: list_item.to_param)).
          to redirect_to(new_user_session_url)
      end
    end
  end

  context "logged in" do
    login_user

    describe "GET #new" do
      it "assigns a new list_item as @list_item" do
        get :new, list_id: list.to_param
        expect(assigns(:list_item)).to be_a_new(ListItem)
      end
    end

    describe "GET #edit" do
      non_user_list = FactoryGirl.create(:list)
      it "cannot find non user list_items" do
        list_item = FactoryGirl.create(:list_item, list: non_user_list)
        expect do
          get :edit,           list_id: non_user_list.to_param,
                               id: list_item.to_param
        end.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "assigns the requested list_item as @list_item" do
        list_item = FactoryGirl.create(:list_item, list: list)
        get :edit, list_id: list.to_param, id: list_item.to_param
        expect(assigns(:list_item)).to eq(list_item)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new ListItem" do
          expect do
            post :create,
                 list_id: list.to_param,
                 list_item: valid_attributes
          end.to change(ListItem, :count).by(1)
        end

        it "assigns a newly created list list_item as @list_item" do
          post :create,
               list_id: list.to_param,
               list_item: valid_attributes
          expect(assigns(:list_item)).to be_a(ListItem)
          expect(assigns(:list_item)).to be_persisted
          expect(assigns(:list_item).list).to eq(list)
        end

        it "redirects to the list" do
          post :create,
               list_id: list.to_param,
               list_item: valid_attributes
          expect(response).to redirect_to(list_path(list))
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved list_item as @list_item" do
          post :create,
               list_id: list.to_param,
               list_item: { food_id: nil }
          expect(assigns(:list_item)).to be_a_new(ListItem)
        end

        it "re-renders the 'new' template" do
          post :create,
               list_id: list.to_param,
               list_item: { food_id: nil }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { name: "New Name" } }

        it "cannot find non user list_items" do
          non_user_list = FactoryGirl.create(:list)
          list_item = FactoryGirl.create(:list_item, list: non_user_list)
          expect do
            put :update,
                list_id: non_user_list.to_param,
                id: list_item.to_param
          end.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "updates the requested list_item" do
          list_item = FactoryGirl.create(:list_item, list: list)
          put :update,
              list_id: list.to_param,
              id: list_item.to_param,
              list_item: new_attributes
          expect(list_item.reload.name).to eq("New Name")
        end

        it "assigns the requested list_item as @list_item" do
          list_item = FactoryGirl.create(:list_item, list: list)
          put :update,
              list_id: list.to_param,
              id: list_item.to_param,
              list_item: new_attributes
          expect(assigns(:list_item)).to eq(list_item)
        end

        it "redirects to the list" do
          list_item = FactoryGirl.create(:list_item, list: list)
          put :update,
              list_id: list.to_param,
              id: list_item.to_param,
              list_item: valid_attributes
          expect(response).to redirect_to(list_url(list))
        end
      end

      context "with invalid params" do
        it "assigns the list_item as @list_item" do
          list_item = FactoryGirl.create(:list_item, list: list)
          put :update,
              list_id: list.to_param,
              id: list_item.to_param,
              list_item: { amount: nil }
          expect(assigns(:list_item)).to eq(list_item)
        end

        it "re-renders the 'edit' template" do
          list_item = FactoryGirl.create(:list_item, list: list)
          put :update,
              list_id: list.to_param,
              id: list_item.to_param,
              list_item: { name: nil }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "cannot find non user list_items" do
        list_item = FactoryGirl.create(:list_item)
        expect do
          delete :destroy,
                 list_id: list.to_param,
                 id: list_item.to_param
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroys the requested list_item" do
        list_item = FactoryGirl.create(:list_item, list: list)
        expect do
          delete :destroy,
                 list_id: list.to_param,
                 id: list_item.to_param
        end.to change(ListItem, :count).by(-1)
      end

      it "redirects to the list" do
        list_item = FactoryGirl.create(:list_item, list: list)
        delete :destroy,
               list_id: list.to_param,
               id: list_item.to_param
        expect(response).to redirect_to(list_url(list))
      end
    end
  end
end
