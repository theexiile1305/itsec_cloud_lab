# Assignment 8: ACME Simplified Part I -- Preparations for a Certificate Authority

In this and the subsequent assignment we will try to build an automatic Certificate Authority (CA) for GitLab users. This CA will eventually stamp out certificates that certify that an automated system acts on behalf of a given GitLab group.

The Architecture calls for two elements:
- Complete Isolation of the initial parsing of the request
- A transport that produces an audit log of all valid requests
- A VM isolated from the internet to host a CA key (or control access to a CA key)

**Your assignment**: 
Find and implement a system that receives JSON requests with a  JWT authentication (see Assignment 6) and parses them in an isolated environment. Authorization should proceed if "request.group" matches a group in the OpenID Connect Data. Pass on successfully authenticated requests to the isolated VM via a transport mechanism that produces an audit log of all requests.