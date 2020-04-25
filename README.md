# EC2-VPN

A bash script to start up an AWS EC2 instance that you've created and use it as a VPN.

I wrote a blog post about creating a personal VPN using an EC2 instance and
OpenVPN, you can read it [here](https://skipgibson.dev/2020/03/29/aws-vpn.html).

- [Prerequisites](#prerequisites)
- [Problems this script solves](#problems-this-script-solves)
- [Set up](#set-up)
    - [Installing the script](#installing-the-script)
- [Using the script](#using-the-script)

## Problems this script solves

- If you leave an EC2 instance running all the time you will be billed as such,
  this script will let you spin up and connect to your instance then tear it
  down afterwards which saves you some pennies.

- Without an [Elastic IP
  address](https://aws.amazon.com/premiumsupport/knowledge-center/intro-elastic-ip-addresses/)
  your instance will be given a new IP upon start up. This script will start
  your EC2 instance and fetch its IP for you.

## Prerequisites

For this script to work you will need the following installed.

- [AWS
  CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) -
  for pulling down EC2 instance information on the command line
- [jq](https://stedolan.github.io/jq/download/) - for JSON parsing
- [openvpn](https://openvpn.net/) - for the VPN

## Set up

There are a few steps you need to go through before being able to use this
script, unfortunately this isn't something I could write a script for.

- You will need an EC2 instance already created on AWS which has OpenVPN
  installed, I wrote a blog post on
  how to do this, you can read it
  [here](https://skipgibson.dev/2020/03/29/aws-vpn.html). We will need the
  `.ovpn` file the set up generates.
- Once you have your `ovpn` file you can either:
  - create a copy of you `ovpn` file at the top level of the repo call
    `.template.ovpn` and replace the remote IP address in the file with
    `REMOTE_IP` or...
  - run the following script to generate a template from your `ovpn` file:
    `scripts/generate-ovpn-template <path-to-file>`.  This will create a file
    called `.template.ovpn` which the main script will use to create an `ovpn`
    file with the new IP of your instance so you can connect to the VPN.
- You will need an AWS IAM policy to allow a user to start and stop your EC2
  instance, as well as a describe all instances. The "user" in this case is this
  script. This is covered in my [blog post](????????????????) written
  specifically about this script. Add the access key ID and secret access key
  you get for this policy to `~/.aws/credentials` file under the name `VPN`.
  e.g.

  ```
  [VPN]
  aws_access_key_id=<key-id>
  aws_secret_access_key=<secret-access-key>
  region=<region-your-ec2-instance-is-in>
  ```

### Installing the script

The script file needs to be in your `PATH`, you can run `make` to have the file
linked to `/usr/local/bin`. If you don't have enough permissions to create the
symlink then you will need to use `sudo make`.

## Using the script

### Fetching Instance Information

To start you need to know your instance ID, you can find this in the AWS EC2
instance console. Run `ec2-vpn update <instance-id>` to populate your instance
information. You only need to do this once, the script will store your instance
information, to fetch up to date information you need only run `ec2-vpn update`.

### Commands

- `start` - Spin up your EC2 instance, note the `connect` command will also
  start your instance before attempting to connect.
- `stop` - Stop your EC2 instance
- `connect` - Spin up your EC2 instance if it isn't already running and connect
  to it using `openvpn`.
- `update [<instance-id>]` - pull the latest information for your instance, or
  pull information for the instance ID provided.
- `id` - will return your EC2 instance ID.
- `ip` - will return the public IP of your EC2 instance.
- `state` - will return the state of your EC2 instance.

