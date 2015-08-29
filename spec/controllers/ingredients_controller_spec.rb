require "rails_helper"

RSpec.describe IngredientsController, type: :controller do
  let(:recipe) do
    FactoryGirl.create(:recipe,
                       user: @current_user || FactoryGirl.create(:user))
  end
  let(:food) do
    FactoryGirl.create(:food, user: @current_user || FactoryGirl.create(:user))
  end
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:ingredient,
                               recipe_id: recipe.id,
                               food_id: food.id)
  end

  context "not logged in" do
    describe "GET #new" do
      it "should redirect to login" do
        expect(get(:new, recipe_id: recipe.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "GET #edit" do
      it "should redirect to login" do
        ingredient = FactoryGirl.create(:ingredient)
        expect(get(:edit, recipe_id: recipe.to_param, id: ingredient.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "POST #create" do
      it "should redirect to login" do
        expect(post(:create,
                    recipe_id: recipe.to_param,
                    ingredient: valid_attributes)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "PUT #update" do
      it "should redirect to login" do
        ingredient = FactoryGirl.create(:ingredient)
        expect(put(:update,
                   recipe_id: recipe.to_param,
                   id: ingredient.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "DELETE #destroy" do
      it "should redirect to login" do
        ingredient = FactoryGirl.create(:ingredient)
        expect(delete(:destroy,
                      recipe_id: recipe.to_param,
                      id: ingredient.to_param)).
          to redirect_to(new_user_session_url)
      end
    end
  end

  context "logged in" do
    login_user

    describe "GET #new" do
      it "assigns a new ingredient as @ingredient" do
        get :new, recipe_id: recipe.to_param
        expect(assigns(:ingredient)).to be_a_new(Ingredient)
      end
    end

    describe "GET #edit" do
      non_user_recipe = FactoryGirl.create(:recipe)
      it "cannot find non user ingredients" do
        ingredient = FactoryGirl.create(:ingredient, recipe: non_user_recipe)
        expect do
          get :edit,           recipe_id: non_user_recipe.to_param,
                               id: ingredient.to_param
        end.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "assigns the requested ingredient as @ingredient" do
        ingredient = FactoryGirl.create(:ingredient, recipe: recipe)
        get :edit, recipe_id: recipe.to_param, id: ingredient.to_param
        expect(assigns(:ingredient)).to eq(ingredient)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Ingredient" do
          expect do
            post :create,               recipe_id: recipe.to_param,
                                        ingredient: valid_attributes
          end.to change(Ingredient, :count).by(1)
        end

        it "assigns a newly created recipe ingredient as @ingredient" do
          post :create,             recipe_id: recipe.to_param,
                                    ingredient: valid_attributes
          expect(assigns(:ingredient)).to be_a(Ingredient)
          expect(assigns(:ingredient)).to be_persisted
          expect(assigns(:ingredient).recipe).to eq(recipe)
        end

        it "redirects to the recipe" do
          post :create,             recipe_id: recipe.to_param,
                                    ingredient: valid_attributes
          expect(response).to redirect_to(recipe_path(recipe))
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved ingredient as @ingredient" do
          post :create,             recipe_id: recipe.to_param,
                                    ingredient: { food_id: nil }
          expect(assigns(:ingredient)).to be_a_new(Ingredient)
        end

        it "re-renders the 'new' template" do
          post :create,             recipe_id: recipe.to_param,
                                    ingredient: { food_id: nil }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { amount: 2 } }

        it "cannot find non user ingredients" do
          non_user_recipe = FactoryGirl.create(:recipe)
          ingredient = FactoryGirl.create(:ingredient, recipe: non_user_recipe)
          expect do
            put :update,             recipe_id: non_user_recipe.to_param,
                                     id: ingredient.to_param
          end.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "updates the requested ingredient" do
          ingredient = FactoryGirl.create(:ingredient, recipe: recipe)
          put :update,             recipe_id: recipe.to_param,
                                   id: ingredient.to_param,
                                   ingredient: new_attributes
          expect(ingredient.reload.amount).to eq(2)
        end

        it "assigns the requested ingredient as @ingredient" do
          ingredient = FactoryGirl.create(:ingredient, recipe: recipe)
          put :update,             recipe_id: recipe.to_param,
                                   id: ingredient.to_param,
                                   ingredient: new_attributes
          expect(assigns(:ingredient)).to eq(ingredient)
        end

        it "redirects to the recipe" do
          ingredient = FactoryGirl.create(:ingredient, recipe: recipe)
          put :update,             recipe_id: recipe.to_param,
                                   id: ingredient.to_param,
                                   ingredient: valid_attributes
          expect(response).to redirect_to(recipe_url(recipe))
        end
      end

      context "with invalid params" do
        it "assigns the ingredient as @ingredient" do
          ingredient = FactoryGirl.create(:ingredient, recipe: recipe)
          put :update,             recipe_id: recipe.to_param,
                                   id: ingredient.to_param,
                                   ingredient: { amount: nil }
          expect(assigns(:ingredient)).to eq(ingredient)
        end

        it "re-renders the 'edit' template" do
          ingredient = FactoryGirl.create(:ingredient, recipe: recipe)
          put :update,             recipe_id: recipe.to_param,
                                   id: ingredient.to_param,
                                   ingredient: { amount: nil }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "cannot find non user ingredients" do
        ingredient = FactoryGirl.create(:ingredient)
        expect do
          delete :destroy,           recipe_id: recipe.to_param,
                                     id: ingredient.to_param
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroys the requested ingredient" do
        ingredient = FactoryGirl.create(:ingredient, recipe: recipe)
        expect do
          delete :destroy,             recipe_id: recipe.to_param,
                                       id: ingredient.to_param
        end.to change(Ingredient, :count).by(-1)
      end

      it "redirects to the recipe" do
        ingredient = FactoryGirl.create(:ingredient, recipe: recipe)
        delete :destroy,           recipe_id: recipe.to_param,
                                   id: ingredient.to_param
        expect(response).to redirect_to(recipe_url(recipe))
      end
    end
  end
end
