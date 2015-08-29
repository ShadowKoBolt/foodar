require "rails_helper"

RSpec.describe FoodsController, type: :controller do
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:food)
  end

  context "not logged in" do
    describe "GET #index" do
      it "should redirect to login" do
        expect(get(:index)).to redirect_to(new_user_session_url)
      end
    end

    describe "GET #new" do
      it "should redirect to login" do
        expect(get(:new)).to redirect_to(new_user_session_url)
      end
    end

    describe "GET #edit" do
      it "should redirect to login" do
        food = FactoryGirl.create(:food)
        expect(get(:edit, id: food.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "POST #create" do
      it "should redirect to login" do
        expect(post(:create, valid_attributes)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "PATCH #update" do
      it "should redirect to login" do
        food = FactoryGirl.create(:food)
        expect(post(:update, id: food.to_param, food: { name: "New Name" })).
          to redirect_to(new_user_session_url)
      end
    end

    describe "DELETE #destroy" do
      it "should redirect to login" do
        food = FactoryGirl.create(:food)
        expect(delete(:destroy, id: food.to_param)).
          to redirect_to(new_user_session_url)
      end
    end
  end

  context "logged in" do
    login_user

    describe 'GET #index' do
      it "assigns all users foods as @foods" do
        user_food = FactoryGirl.create(:food, user: @current_user)
        FactoryGirl.create(:food)
        get :index
        expect(assigns(:foods)).to contain_exactly(user_food)
      end
    end

    describe "GET #new" do
      it "assigns a new food as @food" do
        get :new
        expect(assigns(:food)).to be_a_new(Food)
      end
    end

    describe "GET #edit" do
      it "raises an error if a non-user food is requested" do
        food = FactoryGirl.create(:food)
        expect { get(:edit, id: food.to_param) }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "assigns the requested food as @food" do
        food = FactoryGirl.create(:food, user: @current_user)
        get :edit, id: food.to_param
        expect(assigns(:food)).to eq(food)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Food" do
          expect { post :create, food: valid_attributes }.
            to change(Food, :count).by(1)
        end

        it "assigns a newly created food as @food for the user" do
          post :create, food: valid_attributes
          expect(assigns(:food)).to be_a(Food)
          expect(assigns(:food)).to be_persisted
          expect(assigns(:food).user).to eq(@current_user)
        end

        it "redirects to the food list if no recipe is present" do
          post :create, food: valid_attributes
          expect(response).to redirect_to(foods_url)
        end

        it "redirects to the recipe if recipe is present" do
          recipe = FactoryGirl.create(:recipe)
          post :create, food: valid_attributes.merge(recipe_id: recipe.to_param)
          expect(response).to(redirect_to(new_recipe_ingredient_url(recipe, ingredient: { food_id: Food.last.to_param })))
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved food as @food" do
          post :create, food: { name: "" }
          expect(assigns(:food)).to be_a_new(Food)
        end

        it 're-renders the "new" template' do
          post :create, food: { name: "" }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { name: "New Name" } }

        it "raises an error if a non-user food is posted" do
          food = FactoryGirl.create(:food)
          expect { put :update, id: food.to_param, food: new_attributes }.
            to raise_error(ActiveRecord::RecordNotFound)
        end

        it "updates the requested food" do
          food = FactoryGirl.create(:food, user: @current_user)
          put :update, id: food.to_param, food: new_attributes
          expect(food.reload.name).to eq("New Name")
        end

        it "assigns the requested food as @food" do
          food = FactoryGirl.create(:food, user: @current_user)
          put :update, id: food.to_param, food: valid_attributes
          expect(assigns(:food)).to eq(food)
        end

        it "redirects to the food" do
          food = FactoryGirl.create(:food, user: @current_user)
          put :update, id: food.to_param, food: valid_attributes
          expect(response).to redirect_to(foods_url)
        end
      end

      context "with invalid params" do
        it "assigns the food as @food" do
          food = FactoryGirl.create(:food, user: @current_user)
          put :update, id: food.to_param, food: { name: "" }
          expect(assigns(:food)).to eq(food)
        end

        it 're-renders the "edit" template' do
          food = FactoryGirl.create(:food, user: @current_user)
          put :update, id: food.to_param, food: { name: "" }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "cannot find non-user foods" do
        food = FactoryGirl.create(:food)
        expect do
          delete :destroy, id: food.to_param
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroys the requested food" do
        food = FactoryGirl.create(:food, user: @current_user)
        expect do
          delete :destroy, id: food.to_param
        end.to change(Food, :count).by(-1)
      end

      it "redirects to the foods list" do
        food = FactoryGirl.create(:food, user: @current_user)
        delete :destroy, id: food.to_param
        expect(response).to redirect_to(foods_url)
      end
    end
  end
end
