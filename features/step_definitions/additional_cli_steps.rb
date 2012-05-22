Then /^the output should contain ping pong exchange$/ do
  step %q{the exit status should be 0}
  step %q{the output should contain "sent ping to server"}
  step %q{the output should contain "received pong from server"}
end