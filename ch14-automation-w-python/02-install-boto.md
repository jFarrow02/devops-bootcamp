# Install Boto3 and Connect to AWS

## Step 1: Install Boto3

In your Python project:

- `pip install boto3`

## Step 2: Import and Use Boto3

`main.py`:

```python
import boto3

# Connect to correct AWS account and authenticate
```

`Boto3` uses the same information stored in the `~/.aws/credentials` and
`~/.aws/config` as Terraform does:

| `~/.aws/credentials` | `~/.aws/config` |
| -------------------- | --------------- |
| secret key pair      | default region  |
|                      | output format   |

If these values are already set, **you're done**. If not, you can set them using
the `aws configure` command.
