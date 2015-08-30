require "rails_helper"

RSpec.describe ListItemsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "lists/1/list_items/new").
        to route_to("list_items#new", list_id: "1")
    end

    it "routes to #edit" do
      expect(get: "lists/1/list_items/2/edit").
        to route_to("list_items#edit", list_id: "1", id: "2")
    end

    it "routes to #create" do
      expect(post: "lists/1/list_items").
        to route_to("list_items#create", list_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "lists/1/list_items/2").
        to route_to("list_items#update", list_id: "1", id: "2")
    end

    it "routes to #update via PATCH" do
      expect(patch: "lists/1/list_items/2").
        to route_to("list_items#update", list_id: "1", id: "2")
    end

    it "routes to #destroy" do
      expect(delete: "lists/1/list_items/2").
        to route_to("list_items#destroy", list_id: "1", id: "2")
    end
  end
end
