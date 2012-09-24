class ProjectsController < InheritedResources::Base
  actions :show

private

  def resource
    @project ||= Project.where(name: params[:id]).cache
  end

end
