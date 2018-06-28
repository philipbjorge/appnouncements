RSpec.shared_examples "Release" do

  it "should have attribute type" do
    expect(subject).to have_attribute :type
  end

  it "should initialize successfully as an instance of the described class" do
    expect(subject).to be_a_kind_of described_class
  end

  it { should belong_to(:app) }
  it { should validate_presence_of(:version) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it "should fix params for STI" do
    release = "some release"
    expect(Release.fix_params({ios_release: release}, :ios)).to eq({release: release})
    expect(Release.fix_params({android_release: release}, :android)).to eq({release: release})
  end
end