var MealModalForm = React.createClass({

  render: function() {
    return (
        <div className="modal fade" id="meal-form-modal">
          <div className="modal-dialog">
            <div className="modal-content">
              <form action={this.props.action} method="POST">
                <div className="modal-header">
                  <button type="button" className="close" data-dismiss="modal">
                    <span>&times;</span>
                  </button>
                  <h4 className="modal-title">{ this.props.title }</h4>
                </div>
                <div className="modal-body">
                  <input type="hidden" name="authenticity_token" value={this.props.auth_token} />
                  <input type="hidden" name="meal[recipe_id]" id="meal_recipe_id" />
                  <input type="hidden" name="meal[date]" id="meal_date" />
                  <div className="form-group">
                    <label htmlFor="meal_time">Time</label>
                    <select className="form-control select2" name="meal[time]" id="meal_time">
                      <option value="breakfast">Breakfast</option>
                      <option value="lunch">Lunch</option>
                      <option value="dinner">Dinner</option>
                      <option value="snack">Snack</option>
                    </select>
                  </div>
                  <div className="form-group">
                    <label htmlFor="meal_serves">
                      Serves
                      <small>How many people are eating this meal?</small> 
                    </label>
                    <input className="form-control" type="text" name="meal[serves]" id="meal_serves" />
                  </div>
                </div>
                <div className="modal-footer">
                  <button type="button" className="btn btn-default" data-dismiss="modal">
                    Close
                  </button>
                  <input type="submit" className="btn btn-primary" value="Save" />
                </div>
              </form>
            </div>
          </div>
        </div>
        );
  }
});
