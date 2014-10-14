#Get MEAN with Amazon OpsWorks

##Introduction
The MEAN stack is a JavaScript based application stack that has recently become more and more popular. MEAN is an acronym for MongoDB, Express, Angular.js and Node.js. 

**MongoDB** is a document-oriented NoSQL database system. MongoDB saves data in JSON-like documents with dynamic schema (BSON, binary JSON) which makes it easier to pass data between client and server.

**Express** is lightweight framework used to build web applications in Node.js inspired by the Ruby framework, Sinatra. It provides a number of robust features for building single and multi page web application.

**AngularJS** is an open-source web application framework to create web applications that only require HTML, CSS, and JavaScript on the client side. AngularJS' goal is to enhance web applications with model–view–controller (MVC) capability, to make both development and testing easier.

**Node.js** is a server side JavaScript execution environment. Internally it uses the Google V8 JavaScript engine to execute code, and a large part of the basic modules are written in JavaScript. Node.js applications are designed to maximize throughput and efficiency, using non-blocking I/O and asynchronous events. 

In this article we are going to show how to create a MEAN stack using OpsWorks: we'll deploy a MongoDB Replica Set using a custom layer and the community cookbooks, we'll extend the built-in Node.js layer with some custom recipes and we'll add a Elastic Load Balancer (ELB) to the Node.js layer.

![Can we add here one of those fancy 3D arch diagram?](http://)

##Create a Stack
First, let's create a new stack, give it a name - e.g., MEAN - and select your region of choice.

![Stack creation](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/create_stack.png)

In the *Advanced* settings, change the Chef version to **11.04** and set *Use custom Chef Cookbooks* to **Yes**. Set *Repository type* to **S3** and enter the URL to your custom cookbooks.

![Advanced settings](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/advanced_settings.png)

We'll use the *Custom JSON* setting to override some MongoDB default attributes and to pass some data to our custom recipes.

	{
		"mongodb" : {
			"install_method": "mongodb-org",
			"replicaset_name": "mean-rs",
			"cluster_name": "mean-cluster",
			"auto_configure": {
				"replicaset": true
			},
			"config": {
				"replSet": "mean-rs",
				"dbpath" : "/data",
				"logpath" : "/log/mongodb.log"
			}
		},
		"deploy": {
			"mean_app": {
				"db_user" : "meanuser",
				"db_password" : "mean"	
			}
		}
	}


Click the *Add Stack* button at the bottom of the page to create the stack. 

##Add the MongoDB Replica Set Custom Layer
Now, let's create a custom layer for the MongoDB Replica Set, enter *MongoDB* as a name and *mongodb* as a short name and click *Add Layer* (**Note**: the custom recipes refer to the MongoDB layer using this shortname). Click the layer's *Recipes* action, click on *Edit* at the top of the page and scroll to the *Custom Chef Recipes* section. 

Enter *mean::create-journal-link*, *mongodb::10gen_repo*, *mongodb::default* and *mean::setup-mongo-shell* next to **Setup** and add it to the list. These recipes install MongoDB Server and the shell tool from the MongDB Inc. repository and create a symlink for the journal in the data directory; they will be executed after an instance is booted up. Add *mongodb::replicaset* and *mean::configure-mean-user* to the **Configure** recipes list; these recipes configure the instances to be part od a Replica Set and create a user for the app that we'll deploy later on. Click the *Save* button at the bottom to save the updated configuration.

![MongoDB layer custom recipes](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/custom_mongodb_recipes.png)

Click the layer's *EBS Volumes* action and set the *EBS optimized instances* to **Yes**. Add the EBS Volumes to be attached to each instance in this layer: one RAID1 volume for the data, one volume for the journal and one volume for the logs. Adjust the size and PIOPS of each volume according to your specific needs. Also, if you changed the data or log path in the *Custom JSON* passed to each instance, make sure to reflect those changes in the volume mount points. This setup was done following some [recommandations](http://docs.mongodb.org/ecosystem/platforms/amazon-ec2/) from MongoDB Inc. for deployment on Amazon EC2. 

![MongoDB Layer EBS Volumes](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/ebs_volumes.png)

Finally, add your instances. For a MongoDB Replica Set you'll need an odd number of instances, at least three. Also, make sure your instances are in different Availability Zones (AZs) to increase the availability and fault-tolerance of your database.

![MongoDB instances](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/mongodb_instances.png) 

##Add a Node.js Layer 
For the Application layer we'll use a built-in Node.js Layer. Create a new Layer in your stack, select **Node.js App Server** as *Layer Type* and click *Add Layer* at the bottom left of your screen. 

Click the layer's *Recipes* action, click on *Edit* at the top of the page and scroll to the *Custom Chef Recipes* section. Enter *mean::deploy-mean-app* next to **Deploy** and add it to the list. This recipe will create a configuration file for the MEAN application that contains the MongoDB Replica Set connection string. Click the *Save* button at the bottom to save the updated configuration.

![Node.js Layer custom recipes](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/custom_nodejs_recipes.png)

Add instances to the Node.js Layer. Again, make sure your instances are in different Availability Zones (AZs) to increase the availability and fault-tolerance of your application.

![Node.js instances](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/nodejs_instances.png) 

##Add an Elastic Load Balancer to the Node.js Layer
To spread the requests across the instances in the Node.js Layer we'll attach an Elastic Load Balancer (ELB) to the Layer. You can use an existing ELB or [create a new one](http://docs.aws.amazon.com/gettingstarted/latest/wah-linux/getting-started-create-lb.html) from the EC2 Management Console. Make sure that there are no instances registered to the ELB.

Click the layer's *Network* action, click on *Edit* at the top of the page and select your ELB from the drop-down next to *Elastic Load Balancer*. Click the *Save* button at the bottom to save the updated configuration. 

![Node.js Layer ELB](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/nodejs_elb.png)

##Add the MEAN ToDo Sample app
Lastly, we'll add a ToDo sample Node.js app. Add a new App, enter *Mean App* as name an select *Node.js* from the **Type** drop-down menu (**Note**: if you change the app name, remember to change the respctive section under `deploy` in the *Custom JSON* stack setting). Leave the **Data source type** set to *None* as we'll use our custom MongoDB Layer as data source for our app. Select the repository type and URL for the app and click on *Save* at the bottom of the page. 

![Add MEAN Sample App](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/add_mean_app.png)

Now we can start our instances and we'll be able to access our MEAN ToDo sample app using the ELB DNS name.

![Add MEAN Sample App](https://s3-eu-west-1.amazonaws.com/mean-opsworks-images/mean_app.png)

##Final words
In this article we showed how to deploy a MongoDB Replica Set using a custom layer and the community cookbooks and how to deploy a Node.js application that uses MongoDB as data source. Thanks to Reza Spagnolo for the hints on the MongoDB Replica Set recipes. 
