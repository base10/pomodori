shared_examples "event state notifications" do
  # num_notices and state_action come from the passed-in Proc
  it "builds state_notifications" do
    pomodoro.state_notifications.should_receive(:push).exactly( num_notices ).times
    pomodoro.send( state_action )
  end

  # Solving based on http://stackoverflow.com/questions/9800992/how-to-say-any-instance-should-receive-any-number-of-times-in-rspec/9998793#9998793
  it "processes state_notifications" do
    count = 0

    Pomodori::Notification.any_instance.stub(:process) { |arg| count += 1 }
    pomodoro.send( state_action )

    expect(count).to be >= num_notices
  end

  it "clears state_notifications" do
    pomodoro.send( state_action )
    expect( pomodoro.state_notifications.size ).to eq 0
  end
end
