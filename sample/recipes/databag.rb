require 'rubygems'
require 'aws-sdk'

s3 = AWS::S3.new
obj = s3.buckets['chrisb'].objects['contacts.html']
Chef::Log.info(obj.read)
