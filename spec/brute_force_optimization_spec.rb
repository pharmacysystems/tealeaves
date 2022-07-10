require 'spec_helper'

describe TeaLeaves::BruteForceOptimization do
  it "should have 1014 initial test models" do
    described_class.new([1,2,3,4], 1).initial_test_parameters.size.should == 1014
  end

  it "should have 6 initial test models when not using trend and seasonality" do
    described_class.new([1,2,3,4], 1, {trend: :none, seasonality: :none}).initial_test_parameters.size.should == 6 
  end

  it "should have 42 intial test models when using trend or seasonality but not both" do
    described_class.new([1,2,3,4], 1, {trend: :multiplicative, seasonality: :none}).initial_test_parameters.size.should == 42
    described_class.new([1,2,3,4], 1, {trend: :additive, seasonality: :none}).initial_test_parameters.size.should == 42
    described_class.new([1,2,3,4], 1, {trend: :none, seasonality: :multiplicative}).initial_test_parameters.size.should == 42
    described_class.new([1,2,3,4], 1, {trend: :none, seasonality: :additive}).initial_test_parameters.size.should == 42
  end

  it "should have 78 initial test models when not using trend and any version of seasonality" do
    described_class.new([1,2,3,4], 1, {trend: :none}).initial_test_parameters.size.should == 78
    described_class.new([1,2,3,4], 1, {seasonality: :none}).initial_test_parameters.size.should == 78
  end

  it "should have 222 intial test models when using specific combinations of trend and seasonality" do
    described_class.new([1,2,3,4], 1, {trend: :additive, seasonality: :additive}).initial_test_parameters.size.should == 222
    described_class.new([1,2,3,4], 1, {trend: :additive, seasonality: :multiplicative}).initial_test_parameters.size.should == 222
    described_class.new([1,2,3,4], 1, {trend: :multiplicative, seasonality: :additive}).initial_test_parameters.size.should == 222
    described_class.new([1,2,3,4], 1, {trend: :multiplicative, seasonality: :multiplicative}).initial_test_parameters.size.should == 222
  end

  it "should have 474 intial test models when using specific trend and any seasonality or vice versa" do
    described_class.new([1,2,3,4], 1, {trend: :multiplicative}).initial_test_parameters.size.should == 474
    described_class.new([1,2,3,4], 1, {trend: :additive}).initial_test_parameters.size.should == 474
    described_class.new([1,2,3,4], 1, {seasonality: :multiplicative}).initial_test_parameters.size.should == 474
    described_class.new([1,2,3,4], 1, {seasonality: :additive}).initial_test_parameters.size.should == 474
  end

  it "should work with uniform data" do
    described_class.new([1,1,1,1], 1).optimize
  end

  it "should produce an initial model" do

  end
end
