# Assignment 10: Closing the Circle (of Logs)

In the first assignment, you defined a log group and/or an S3 bucket for CloudTrail logs. Now it's time to get these logs into a Detection/Response-ready system, Elasticsearch.

You have now three options:
- Follow the instructions at https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_OpenSearch_Stream.html to create an OpenSearch Cluster and stream CloudWatch Logs with a Lambda. This is the most expensive option; but also the easiest.
- Use a Lambda triggered by an S3 delivery to ingest the file into an OpenSearch Cluster. An Example is here: https://github.com/pacohope/cloudtrail-logs-to-AWS-Elasticsearch-Service. This allows one also to ingest historic data
- Set up your own ELK Stack (Elasticsearch, Logstash and Kibana) and pull events from CloudWatch Logs into Logstash, process them and store them in Elasticsearch. (You could also do this from your computer).

Eventually, you should have a Kibana console where you can search for CloudTrail events at high speed.

Investigate the possibilities of setting Alerts, and set an alert when a IAM User is created or deleted.

**Bonus**: Hook up your CA from Assignments 8 & 9 to your new logging system (log certificates, requests, and SSH sessions)

## Solution
- Setup ELK Stack on ec2-instance via tutorial https://acpasavarjana.medium.com/setting-up-elk-stack-elastic-stack-on-aws-ec2-instance-fc2e1b006fe3

## Installation
- sudo apt-get update
- sudo apt-get upgrade
- sudo apt-get install default-jre
- wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
- sudo apt-get install apt-transport-https
- echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
- sudo apt-get update && sudo apt-get install elasticsearch
- sudo vim /etc/elasticsearch/elasticsearch.yml
    - node.name: node-1
    - network.host: 127.0.0.1
    - http.port: 9200
    - cluster.initial_master_nodes: ["node-1"]
- sudo vim /etc/elasticsearch/jvm.options
    - -Xms4g 
    - -Xmx4g
- sudo service elasticsearch start
- curl http://localhost:9200
- sudo apt-get install logstash
- vim /home/ubuntu/test_log.log
    ```
    INFO somelog
    ERR somelog2
    ERR somelog3
    ```
- sudo vim /etc/logstash/conf.d/apache-01.conf
    ```
    input {
            file {
                    path => "/home/test_log.log"
                    start_position => "beginning"
            }
    }output{
            elasticsearch {
                    hosts => ["localhost:9200"]
            }
    }
    ```
- sudo service logstash start
- sudo curl -XGET 'localhost:9200/_cat/indices?v&pretty'
- sudo apt-get install kibana
- sudo vim /etc/kibana/kibana.yml
    - server.port: 5601
    - server.host: "0.0.0.0"
    - elasticsearch.hosts: ["http://127.0.0.1:9200"]
- sudo service kibana start
- Now visit http://<ec2-instance-ip>:5601

### Configuration
- generate password for elasticsearch via sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto
- enable AWS Cloudtrail Logs via sudo vim /etc/elasticsearch/elasticsearch.yml
    - xpack.security.enabled: true
    - xpack.security.authc.api_key.enabled: true
- configure kibana via sudo vim /etc/kibana/kibana.yml
    - elasticsearch.username
    - elasticsearch.password
- further configuration is needed, but it is really easy