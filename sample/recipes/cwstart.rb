execute "send logs to CloudWatch" do
  command "nohup sudo aws --region us-east-1 logs push --config-file /tmp/cwlogs &"
end

