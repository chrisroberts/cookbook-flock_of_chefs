
if(node.name == 'zkslave.chrisroberts')
  file '/opt/sub-test' do
    action :nothing
    content "Received at: #{Time.now}"
    wait_until do
      FlockOfChefs.me
    end
  end
else
  file '/opt/not-test' do
    content 'test'
    remote_notifies :create, 'file[/opt/sub-test]', :node => 'zkslave.chrisroberts'
  end
end
