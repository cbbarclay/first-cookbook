execute "create log group" do
  command "aws --region us-east-1 logs create-log-group --log-group-name #{node[:opsworks][:stack][:name]}"
  not_if "aws --region us-east-1 logs describe-log-groups | grep #{node[:opsworks][:stack][:name]}"
  action :run
end

execute "create log stream" do
  command "aws --region us-east-1 logs create-log-stream --log-group-name #{node[:opsworks][:stack][:name]} --log-stream-name #{node[:opsworks][:instance][:hostname]}"
  not_if "aws --region us-east-1 logs describe-log-streams --log-group-name #{node[:opsworks][:stack][:name]} | grep #{node[:opsworks][:instance][:hostname]}"
  action :run
end
