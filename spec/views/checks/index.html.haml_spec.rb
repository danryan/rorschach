require 'spec_helper'

describe "checks/index" do
  before(:each) do
    assign(:checks, [
      stub_model(Check,
        :metric => "Metric",
        :warning => "9.99",
        :critical => "9.99",
        :resolve => false,
        :repeat => false,
        :interval => 1
      ),
      stub_model(Check,
        :metric => "Metric",
        :warning => "9.99",
        :critical => "9.99",
        :resolve => false,
        :repeat => false,
        :interval => 1
      )
    ])
  end

  it "renders a list of checks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Metric".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
