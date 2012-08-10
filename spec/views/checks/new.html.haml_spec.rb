require 'spec_helper'

describe "checks/new" do
  before(:each) do
    assign(:check, stub_model(Check,
      :metric => "MyString",
      :warning => "9.99",
      :critical => "9.99",
      :resolve => false,
      :repeat => false,
      :interval => 1
    ).as_new_record)
  end

  it "renders new check form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => checks_path, :method => "post" do
      assert_select "input#check_metric", :name => "check[metric]"
      assert_select "input#check_warning", :name => "check[warning]"
      assert_select "input#check_critical", :name => "check[critical]"
      assert_select "input#check_resolve", :name => "check[resolve]"
      assert_select "input#check_repeat", :name => "check[repeat]"
      assert_select "input#check_interval", :name => "check[interval]"
    end
  end
end
