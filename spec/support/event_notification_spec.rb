shared_examples "event state notifications" do
  # num_notices and state_action come from the passed-in Proc
  it "builds state_notifications" do
    context_object.state_notifications.should_receive(:push).exactly( num_notices ).times
    context_object.send( state_action )
  end

  # Solving based on http://stackoverflow.com/questions/9800992/how-to-say-any-instance-should-receive-any-number-of-times-in-rspec/9998793#9998793
  it "processes state_notifications" do
    count = 0

    Pomodori::Notification.any_instance.stub(:process) { |arg| count += 1 }
    context_object.send( state_action )

    expect(count).to be >= num_notices
  end

  it "clears state_notifications" do
    context_object.send( state_action )
    expect( context_object.state_notifications.size ).to eq 0
  end
end
