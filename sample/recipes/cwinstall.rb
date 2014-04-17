package "python-pip" do
    action :install
end 

execute "install" do
  command "pip install --upgrade https://s3.amazonaws.com/cf8427e/awscli-1.3.0.tar.gz"
  command "pip install --upgrade https://s3.amazonaws.com/cf8427e/botocore-0.34.0.tar.gz"

  action :run
end
