# Assignment 7: The Data Diode
(This exercise can be completed using the AWS Web Console and/or Terraform)

The goal of this exercise is to set up a "data diode": Two components A and B connected in a way that information can only pass from A to B, and never from B to A.

### Step 1: Setups
- Create your own, new VPC in a region which has "free" VPCs (maximum 5), check eu-central-1, eu-west-1, us-east-1, us-west-2
- Create two (nano) instances A and B in two different subnets in that VPC. Ensure that you can SSH into these instances by setting up a "Key Pair" resource in EC2.
- SSH into both machines in different terminals.
- Install nginx on host B (sudo apt install nginx)
- Verify that you can not access host B from host A (run `curl <ip>`, where ip is both private and public).


### Step 2: Make them talk!
- Now, examine the Security Groups of both instances to allow host A to access nginx on host B.
- Try to only keep the minimal set of rules necessary. Test if host B even needs an egress rule!

### Step 3: The one-way street
- Try to stop host B from answering host A's HTTP request using only host B's security group. (This will fail)
- Look at the Network ACL currently attached to both A's and B's subnet.
- Introduce a new Network ACL that only allows inbound UDP packets
- Associate that Network ACL with host B's subnet
- Verify that now host's A's HTTP requests are blocked.

Now, try to use netcat to send UDP packets from A to B and B to A -- only one way should work!
You may hit some initial problems - think of what the Network ACL does to connections!

### Bonus: A one-way street across the Atlantic
For this part, you have to create two VPCs with different IP ranges both in some eu- and us- region. For data protection reasons, the machine in the US should only be able to send data to the EU, but not the other way round. Create a peering connection between the VPCs, set up the routing table and set up the network ACLs to allow free in-VPC communication but only one-way UDP communication from US to EU.

---

## Solution without bonus exercise
- Create a key-pair in order to access the ec2 instances
- Create a internet gateway, associate it with the just created vpc `10.0.0.0/23` to get inbound and outbound access to the internt. Therfore you have to modify the main route table so that the internet gateway can access the vpc.
- Create two subnets `10.0.0.0/24` for instance A and `10.0.1.0/24` for instance B
- Create the two instances A and B with `instance_type = t4g.nano` and amazon linux as operating system. Additionally configure for each instance a separate security group.
- The ACL-rules are a stateless protocol, i.e. each packet is considered individually with respect to ingress and egress rules.
- In contrast, security groups are a stateful protocol, meaning that only the initial connection is considered, allowing subsequent traffic to be automatically captured by the rules.

### Host A
- public: `52.59.185.235`
- private: `10.0.0.193`

### Host B:
- public: `52.59.19.114`
- private: `10.0.1.143`


## Setup on Host B with amazon linux
```
sudo su
yum check-update
yum update -y
amazon-linux-extras install nginx1
yum install nginx
yum clean metadata
yum -y install nginx
nginx -v
service nginx start
chkconfig nginx on chkconfig nginx on
service nginx status
pgrep nginx
ss -tlpn | grep :80
nano /usr/share/nginx/html/index.html
```

## Links
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
