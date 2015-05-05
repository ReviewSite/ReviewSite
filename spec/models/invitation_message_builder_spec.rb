require 'spec_helper'

describe InvitationMessageBuilder do
  describe '#build' do
    let(:invitation) { build(:invitation) }
    let(:builder) { InvitationMessageBuilder.new }
    let(:message) { 'some message' }

    describe 'invitation has not been set' do
      it 'should not build messages with an invitation' do
        builder.should_not_receive(:build_messages).with(message)
        builder.build(message)
      end
    end

    describe 'invitation has been set' do
      it 'should build messages with an invitation' do
        builder.should_receive(:build_messages).with(message)
        builder.with(invitation).build(message)
      end
    end
  end

  describe '#with' do
    let(:builder) { InvitationMessageBuilder.new }
    subject { builder.with(invitation) }

    describe 'arguement is an Invitation' do
      let(:invitation) { build(:invitation) }
      it { should be_an_instance_of InvitationMessageBuilder }
    end

    describe 'arguement is not an Invitation' do
      let(:invitation) { Object.new }
      it { should be_nil }
    end
  end

  describe '#error_message' do
    let(:builder) { InvitationMessageBuilder.new }

    describe 'should return formatted string' do
      before { builder.stub(:errors).and_return(['error_one', 'error_two']) }
      subject { builder.error_message }
      it { should == "error_one\nerror_two"}
    end
  end

  describe '#success_message' do
    describe 'should return formatted string' do
      subject { builder.success_message }

      describe 'when no email is false' do
        before { builder.stub(:successes).and_return(['success_one', 'success_two']) }
        let(:builder) { InvitationMessageBuilder.new }
        it { should == 'An invitation has been sent to: success_one, success_two' }
      end

      describe 'when no email is true' do
        before { builder.stub(:successes).and_return(['success_one', 'success_two'], ['success_one', 'success_two']) }
        let(:builder) { InvitationMessageBuilder.new(true) }
        it { should == 'An invitation has been created for: success_one, success_two' }
      end
    end
  end
end