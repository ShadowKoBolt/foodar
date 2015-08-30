class ListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_list_item, only: [:show, :edit, :update, :destroy]

  def new
    params[:list_item] ||= { x: 1 }
    @list_item = ListItem.new(list_item_params)
  end

  def edit
  end

  def create
    @list_item = ListItem.new(list_item_params)
    if @list_item.save
      redirect_to @list,
        notice: t("notice.created", model: ListItem.model_name.human)
    else
      render :new
    end
  end

  def update
    if @list_item.update(list_item_params)
      redirect_to @list,
        notice: t("notice.updated", model: ListItem.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @list_item.destroy
    redirect_to list_url(@list),
      notice: t("notice.destroyed", model: ListItem.model_name.human)
  end

  private

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_list_item
    @list_item = @list.list_items.find(params[:id])
  end

  def list_item_params
    params.
      require(:list_item).
      permit(:name, :aisle).
      merge(list_id: @list.id)
  end
end
