execute "install" do
  command "wget https://s3.amazonaws.com/cf8427e/Setup/awslogs-agent-setup.py"
  command "chmod u+x awslogs-agent-setup.py"
  command "./awslogs-agent-setup.py -r us-east-1 -c /tmp/cwlogs"

  action :run
end


