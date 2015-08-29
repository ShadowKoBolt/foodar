require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:recipe)
  end

  context "not logged in" do
    describe "GET #index" do
      it "should redirect to login" do
        expect(get(:index)).to redirect_to(new_user_session_url)
      end
    end

    describe "GET #show" do
      recipe = FactoryGirl.create(:recipe)
      it "should redirect to login" do
        expect(get(:show, id: recipe.to_param)).
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
        recipe = FactoryGirl.create(:recipe)
        expect(get(:edit, id: recipe.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "POST #create" do
      it "should redirect to login" do
        expect(post(:create, recipe: valid_attributes)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "PUT #update" do
      it "should redirect to login" do
        recipe = FactoryGirl.create(:recipe)
        expect(put(:update, id: recipe.to_param)).
          to redirect_to(new_user_session_url)
      end
    end

    describe "DELETE #destroy" do
      it "should redirect to login" do
        recipe = FactoryGirl.create(:recipe)
        expect(delete(:destroy, id: recipe.to_param)).
          to redirect_to(new_user_session_url)
      end
    end
  end

  context "logged in" do
    login_user

    describe "GET #index" do
      it "assigns user recipes as @recipes" do
        user_recipe = FactoryGirl.create(:recipe, user: @current_user)
        FactoryGirl.create(:recipe)
        get :index
        expect(assigns(:recipes)).to contain_exactly(user_recipe)
      end
    end

    describe "GET #show" do
      it "should not find non-user recipes" do
        recipe = FactoryGirl.create(:recipe)
        expect { get(:show, id: recipe.to_param) }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "assigns user recipe as @recipe" do
        recipe = FactoryGirl.create(:recipe, user: @current_user)
        get(:show, id: recipe.to_param)
        expect(assigns(:recipe)).to eq(recipe)
      end
    end

    describe "GET #new" do
      it "assigns a new recipe as @recipe" do
        get :new
        expect(assigns(:recipe)).to be_a_new(Recipe)
      end
    end

    describe "GET #edit" do
      it "cannot find non user recipes" do
        recipe = FactoryGirl.create(:recipe)
        expect { get :edit, id: recipe.to_param }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "assigns the requested recipe as @recipe" do
        recipe = FactoryGirl.create(:recipe, user: @current_user)
        get :edit, id: recipe.to_param
        expect(assigns(:recipe)).to eq(recipe)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Recipe" do
          expect do
            post :create, recipe: valid_attributes
          end.to change(Recipe, :count).by(1)
        end

        it "assigns a newly created user recipe as @recipe" do
          post :create, recipe: valid_attributes
          expect(assigns(:recipe)).to be_a(Recipe)
          expect(assigns(:recipe)).to be_persisted
          expect(assigns(:recipe).user).to eq(@current_user)
        end

        it "redirects to the created recipe" do
          post :create, recipe: valid_attributes
          expect(response).to redirect_to(recipe_url(Recipe.last))
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved recipe as @recipe" do
          post :create, recipe: { recipe_id: nil }
          expect(assigns(:recipe)).to be_a_new(Recipe)
        end

        it "re-renders the 'new' template" do
          post :create, recipe: { recipe_id: nil }
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { { serves: 2 } }

        it "cannot find non user recipes" do
          recipe = FactoryGirl.create(:recipe)
          expect { put :update, id: recipe.to_param }.
            to raise_error(ActiveRecord::RecordNotFound)
        end

        it "updates the requested recipe" do
          recipe = FactoryGirl.create(:recipe, user: @current_user)
          put :update, id: recipe.to_param, recipe: new_attributes
          expect(recipe.reload.serves).to eq(2)
        end

        it "assigns the requested recipe as @recipe" do
          recipe = FactoryGirl.create(:recipe, user: @current_user)
          put :update, id: recipe.to_param, recipe: new_attributes
          expect(assigns(:recipe)).to eq(recipe)
        end

        it "redirects to the recipe" do
          recipe = FactoryGirl.create(:recipe, user: @current_user)
          put :update, id: recipe.to_param, recipe: valid_attributes
          expect(response).to redirect_to(recipe_url(recipe))
        end
      end

      context "with invalid params" do
        it "assigns the recipe as @recipe" do
          recipe = FactoryGirl.create(:recipe, user: @current_user)
          put :update, id: recipe.to_param, recipe: { serves: nil }
          expect(assigns(:recipe)).to eq(recipe)
        end

        it "re-renders the 'edit' template" do
          recipe = FactoryGirl.create(:recipe, user: @current_user)
          put :update, id: recipe.to_param, recipe: { serves: nil }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "cannot find non user recipes" do
        recipe = FactoryGirl.create(:recipe)
        expect { delete :destroy, id: recipe.to_param }.
          to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroys the requested recipe" do
        recipe = FactoryGirl.create(:recipe, user: @current_user)
        expect do
          delete :destroy, id: recipe.to_param
        end.to change(Recipe, :count).by(-1)
      end

      it "redirects to the recipes list" do
        recipe = FactoryGirl.create(:recipe, user: @current_user)
        delete :destroy, id: recipe.to_param
        expect(response).to redirect_to(recipes_url)
      end
    end
  end
end
