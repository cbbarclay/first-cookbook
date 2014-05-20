bash "start_service" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  wget https://s3.amazonaws.com/cf8427e/Setup /awslogs-agent-setup.py
  chmod u+x awslogs-agent-setup.py
  ./awslogs-agent-setup.py -r us-east-1 -c /tmp/cwlogs.cfg
  EOH
end


