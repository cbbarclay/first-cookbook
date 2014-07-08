directory "/opt/aws/cloudwatch" do
 recursive true
end


remote_file "/opt/aws/cloudwatch" do
source "https://s3.amazonaws.com/aws-cloudwatch/downloads/awslogs-agent-setup-v1.0.py"
mode "0755"
end
