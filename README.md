# EC2-VPN

A bash script to start up an AWS EC2 instance that you've created and use it as a VPN,
making sure to tear the EC2 instance down when you are done using it. It
requires a little set up but once set up it works a treat.

I wrote a blog post about creating a personal VPN using an EC2 instance and
OpenVPN, you can read it [here](https://skipgibson.dev/2020/03/29/aws-vpn.html).

- [Problems this script solves](#problems-this-script-solves)
- [Prerequisites](#prerequisites)
  - [Tools](#tools)
  - [EC2 Instance](#ec2-instance)
  - [ovpn file](#ovpn-file)
  - [AWS Permissions](#aws-permissions)
- [Set up](#set-up)
  - [Generating ovpn template](#generating-ovpn-template)
  - [Installing the script](#installing-the-script)
- [Using the script](#using-the-script)
  - [Commands](#commands)
  - [ENV variables](#env-variables)

## Problems this script solves

- If you leave an EC2 instance running all the time you will be billed as such,
  this script will let you spin up and connect to your instance then tear it
  down afterwards which saves you some pennies.

- Without an [Elastic IP
  address](https://aws.amazon.com/premiumsupport/knowledge-center/intro-elastic-ip-addresses/)
  your instance will be given a new IP upon start up. This script will start
  your EC2 instance and fetch its IP for you.

## Prerequisites

### Tools

For this script to work you will need the following installed.

- [AWS
  CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) -
  for pulling down EC2 instance information on the command line
- [jq](https://stedolan.github.io/jq/download/) - for JSON parsing
- [openvpn](https://openvpn.net/) - for the VPN

### EC2 Instance

You will need an EC2 instance already created on AWS which has OpenVPN
installed, You can read the post I wrote about setting that up right
[here](https://skipgibson.dev/2020/03/29/aws-vpn.html). We will need the `.ovpn`
file the set up generates.

### ovpn file

OpenVPN requires a `.ovpn` file when connecting to a VPN, this file contains
everything it needs to do so, including the public IP address of the server
you're connecting to. You can get this file as a final step when creating your
EC2 instance, checkout the [EC2 Instance](#ec2-instance) section for more
details.

### AWS Permissions

You will also need a user set up on AWS with permissions to interact with your
EC2 instance, this is needed by AWS CLI. Without the permissions and credentials
for that user the script can't do very much.

I wrote a blog post about this script that covers creating the correct AWS
permissions, you can read that
[here](https://skipgibson.dev/2020/04/26/ec2-vpn-script.html).

If you know what you're doing then you just need permissions to:

- Start instances
- Stop instances
- Describe instances

Make sure to add the credentials for the user who has permissions to interact
with your EC2 instance in the `~/.aws/credentials` file, e.g.

```
[VPN]
aws_access_key_id=<key-id>
aws_secret_access_key=<secret-access-key>
region=<region-your-ec2-instance-is-in>
```

Note that the script assumes there is an AWS profile called `VPN`, if you want
to use an already existing AWS profile, you can set the environment variable
`AWS_VPN_PROFILE` and the script will use that instead of the default `VPN`.

## Set up

### Generating ovpn template

This step requires the `ovpn` file generated at the end of setting up the EC2
instance, check out the [EC2 Instance](#ec2-instance) in the prerequisites
section for more details.

Once you have your `ovpn` file you can either:
- create a copy of you `ovpn` file at the top level of the repo called
  `.template.ovpn` and replace the remote IP address in the file with
  the string `REMOTE_IP` or...
- run the following script to generate a template from your `ovpn` file:
  `scripts/generate-ovpn-template <path-to-ovpn-file>`.  This will create a
  file called `.template.ovpn` which the main script will use to create an
  `ovpn` file with the new public IP of your instance so you can connect to
  the VPN.

### Installing the script

The script file needs to be in your `PATH`, you can run `make` to have the file
linked to `/usr/local/bin`. If you don't have enough permissions to create the
symlink then you will need to use `sudo make`.

### Fetching Instance Information

To start you need to know your instance ID, you can find this in the AWS EC2
instance console. Run `ec2-vpn update <instance-id>` to populate your instance
information. You only need to do this once, the script will store your instance
information, to fetch up to date information you need only run `ec2-vpn update`.

## Using the script

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

### ENV variables

- `AWS_VPN_PROFILE` - The script assumes there is an AWS Profile with the name
  `VPN` and attempts to use that, as mentioned in the [AWS
  Permissions](#aws-permissions) section. However if you wish to use a different
  profile just set this environment variable with the name of the profile and
  that profile will be used instead.
