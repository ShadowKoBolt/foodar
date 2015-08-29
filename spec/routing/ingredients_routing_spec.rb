require "rails_helper"

RSpec.describe IngredientsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "recipes/1/ingredients/new").
        to route_to("ingredients#new", recipe_id: "1")
    end

    it "routes to #edit" do
      expect(get: "recipes/1/ingredients/2/edit").
        to route_to("ingredients#edit", recipe_id: "1", id: "2")
    end

    it "routes to #create" do
      expect(post: "recipes/1/ingredients").
        to route_to("ingredients#create", recipe_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "recipes/1/ingredients/2").
        to route_to("ingredients#update", recipe_id: "1", id: "2")
    end

    it "routes to #update via PATCH" do
      expect(patch: "recipes/1/ingredients/2").
        to route_to("ingredients#update", recipe_id: "1", id: "2")
    end

    it "routes to #destroy" do
      expect(delete: "recipes/1/ingredients/2").
        to route_to("ingredients#destroy", recipe_id: "1", id: "2")
    end
  end
end
