var DuplicateModalForm = React.createClass({

  render: function() {
    return (
        <div className="modal fade" id="duplicate-form-modal">
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
                  <input type="hidden" name="start_date" id="duplicate_start_date" />
                  <input type="hidden" name="end_date" id="duplicate_end_date" />
                  <div className="form-group date-container">
                    <label htmlFor="duplicate_target_date">
                      Date
                      <small>When would you like to duplicate this select to?</small> 
                    </label>
                    <input className="form-control date-select" type="text" name="target_date" id="duplicate_target_date" />
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
