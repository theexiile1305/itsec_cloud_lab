# Assignment 11: Whodunit?

- You have spotted an unusual instance in the CIS account! Figure out who really started the instance.
- Follow the steps as described in the lecture.
- Note down what you should do if you spotted such an instance in your Account!

**Bonus**: Can you figure out what the instance is doing?

---

## Solution: Find out who really started the instance
### Investigate instance `i-0b0ba689251d3ef76` further
- public ip: `18.184.41.35`
- public dns: `ec2-18-184-41-35.eu-central-1.compute.amazonaws.com`
- private ip: `172.31.20.152`
- private dns: `ip-172-31-20-152.eu-central-1.compute.internal`
- ami: ubuntu with image `ami-0a49b025fffbbdac6`
- key pair `operation` (id: `key-0b413d7e812713c96`)
- no flow logs
- supicious cpu usage nearly by 99 %
    - 2021-12-21 20:45 UTC - 2021-12-21 21:15 UTC
    - 2021-12-22 08:55 UTC - current
- volume `vol-0ad0269bf5308a637` with 8 GB, not encrypted
- vpc `vpc-05c937f058d7fd8fa`
- subnet `subnet-0b6a328fac28c77b0`
    - network acl `acl-0eb2d886d2f8b8bcd`
        - inbound rule: all traffic is allowed
        - outbound rule: all traffic is allowed
    - route table associated with `igw-07623c43a5c27060e`
- security group `sg-03eb25c4639963c8f`
    - inbound rule: `SSH - 22` for all ips
    - outbound rule: all traffic is allowed

### Who has been the ec2-instance `i-0b0ba689251d3ef76` created?
- Search for the instance name `i-0b0ba689251d3ef76 ` in CloudTrail
- According to https://eu-central-1.console.aws.amazon.com/cloudtrail/home?region=eu-central-1#/events/4610a4ea-8983-47d3-87e3-355a9539d779 the user `7875be2c` launched the instance
- This user said, that he hasn't started this instance

### Further investigation
- See what supicious activites happend in this area of time
- https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1#logsV2:log-groups/log-group/mfuchs-cloudwatch-activities/log-events$3Fstart$3D1640041200000$26end$3D1640127599000$26filterPattern$3DASIASDT3TGVYSHXTN6J3
- Someone created an accesskey `AKIASDT3TGVYWS5EGJUM` for the user `7875be2c`
- After that this accesskey is used to automaticlly configure the ec2-instance with dependencies via terraform

**Final solution**: internal employee with rights to create an accesskey associated to someone else


## Solution: What is the instance doing?
- just download the system log form the instance menu
- analyze the log file `i-0b0ba689251d3ef76.log` 
- reason for heavy cpu consumption: `md5sum /dev/urandom`