require 'spec_helper'

describe HomeController do

  describe "#index" do
    before { get :index }
    it { should respond_to :index }
    it { should render_template :index }
  end

end
