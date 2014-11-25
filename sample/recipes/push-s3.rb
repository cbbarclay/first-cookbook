getS3.rb
require 'rubygems'
require 'aws-sdk'

s3 = AWS::S3.new
key = File.basename(file_name)
s3.buckets[bucket_name].objects[key].write(:file => file_name)
Chef::Log.info("Uploading file #{file_name} to bucket #{bucket_name}.")
