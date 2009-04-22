class OverheadTimeEntryActivityController < ApplicationController
  unloadable

  before_filter :require_admin
  helper :overhead
  include OverheadHelper
  
  def index
    if params[:custom_field]
      @field = TimeEntryActivityCustomField.find_by_id(params[:custom_field])
      @values = select_values_for_field(@field)
    end
    @values ||= []

    @selected = params[:selected] || ''
    
    render :partial => 'values'
  end
end
