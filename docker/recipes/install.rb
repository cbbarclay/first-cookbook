package "docker" do  
  action :install
end 

service "docker" do
  action :start
end
