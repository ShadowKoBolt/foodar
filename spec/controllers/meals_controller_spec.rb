require "rails_helper"

RSpec.describe MealsController, type: :controller do
  let(:valid_attributes) do
    recipe = FactoryGirl.create(:recipe)
    FactoryGirl.attributes_for(:meal, recipe_id: recipe.id)
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
        meal = FactoryGirl.create(:meal)
        expect(get(:edit, id: meal.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "POST #create" do
      it "should redirect to login" do
        expect(post(:create, meal: valid_attributes)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "PUT #update" do
      it "should redirect to login" do
        meal = FactoryGirl.create(:meal)
        expect(put(:update, id: meal.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "DELETE #destroy" do
      it "should redirect to login" do
        meal = FactoryGirl.create(:meal)
        expect(delete(:destroy, id: meal.to_param)).
          to redirect_to(new_user_session_url)
      end
    end
  end

  context "logged in" do
    login_user

    describe "GET #index" do
      it "assigns user meals as @meals" do
        user_meal = FactoryGirl.create(:meal, user: @current_user)
        FactoryGirl.create(:meal)
        get :index
        expect(assigns(:meals)).to contain_exactly(user_meal)
      end
    end

    describe "GET #new" do
      it "assigns a new meal as @meal" do
        get :new
        expect(assigns(:meal)).to be_a_new(Meal)
      end
    end

    describe "GET #edit" do
      it "cannot find non user meals" do
        meal = FactoryGirl.create(:meal)
        expect { get :edit, { id: meal.to_param } }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "assigns the requested meal as @meal" do
        meal = FactoryGirl.create(:meal, user: @current_user)
        get :edit, { id: meal.to_param }
        expect(assigns(:meal)).to eq(meal)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Meal" do
          expect do
            post :create, { meal: valid_attributes }
          end.to change(Meal, :count).by(1)
        end

        it "assigns a newly created user meal as @meal" do
          post :create, { meal: valid_attributes }
          expect(assigns(:meal)).to be_a(Meal)
          expect(assigns(:meal)).to be_persisted
          expect(assigns(:meal).user).to eq(@current_user)
        end

        it "redirects to the created meal" do
          post :create, { meal: valid_attributes }
          expect(response).to redirect_to(meals_url)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved meal as @meal" do
          post :create, { meal: { recipe_id: nil } }
          expect(assigns(:meal)).to be_a_new(Meal)
        end

        it "re-renders the 'new' template" do
          post :create, { meal: { recipe_id: nil } }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { serves: 2 } }

        it "cannot find non user meals" do
          meal = FactoryGirl.create(:meal)
          expect { put :update, { id: meal.to_param } }.
            to raise_error(ActiveRecord::RecordNotFound)
        end

        it "updates the requested meal" do
          meal = FactoryGirl.create(:meal, user: @current_user)
          put :update, { id: meal.to_param, meal: new_attributes }
          expect(meal.reload.serves).to eq(2)
        end

        it "assigns the requested meal as @meal" do
          meal = FactoryGirl.create(:meal, user: @current_user)
          put :update, { id: meal.to_param, meal: new_attributes }
          expect(assigns(:meal)).to eq(meal)
        end

        it "redirects to the meal" do
          meal = FactoryGirl.create(:meal, user: @current_user)
          put :update, { id: meal.to_param, meal: valid_attributes }
          expect(response).to redirect_to(meals_url)
        end
      end

      context "with invalid params" do
        it "assigns the meal as @meal" do
          meal = FactoryGirl.create(:meal, user: @current_user)
          put :update, { id: meal.to_param, meal: { serves: nil } }
          expect(assigns(:meal)).to eq(meal)
        end

        it "re-renders the 'edit' template" do
          meal = FactoryGirl.create(:meal, user: @current_user)
          put :update, { id: meal.to_param, meal: { serves: nil } }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "cannot find non user meals" do
        meal = FactoryGirl.create(:meal)
        expect { delete :destroy, { id: meal.to_param } }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroys the requested meal" do
        meal = FactoryGirl.create(:meal, user: @current_user)
        expect do
          delete :destroy, { id: meal.to_param }
        end.to change(Meal, :count).by(-1)
      end

      it "redirects to the meals list" do
        meal = FactoryGirl.create(:meal, user: @current_user)
        delete :destroy, { id: meal.to_param }
        expect(response).to redirect_to(meals_url)
      end
    end
  end
end
