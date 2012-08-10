require 'spec_helper'

describe "checks/show" do
  before(:each) do
    @check = assign(:check, stub_model(Check,
      :metric => "Metric",
      :warning => "9.99",
      :critical => "9.99",
      :resolve => false,
      :repeat => false,
      :interval => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Metric/)
    rendered.should match(/9.99/)
    rendered.should match(/9.99/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/1/)
  end
end
