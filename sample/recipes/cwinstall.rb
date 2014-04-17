execute "install" do
  command "sudo apt-get install python-pip"
  command "sudo pip install --upgrade https://s3.amazonaws.com/cf8427e/awscli-1.3.0.tar.gz"
  command "sudo pip install --upgrade https://s3.amazonaws.com/cf8427e/botocore-0.34.0.tar.gz"
  action :run
end
