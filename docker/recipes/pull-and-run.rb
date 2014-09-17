include_recipe 'deploy'

docker build -t="image-id" .
docker run -p node[:opsworks][:instance][:ip]:80:80 -d image-id


node[:my_apps].each do |name, image|  
  script "pull_app_#{name}_image" do
    interpreter "bash"
    user "root"
    code <<-EOH
      docker pull #{image}
    EOH
  end
end 

node[:my_apps].each do |name, image|  
  script "run_app_#{name}_container" do
    interpreter "bash"
    user "root"
    code <<-EOH
      docker run -d --name=#{name} #{image}
    EOH
  end
end
