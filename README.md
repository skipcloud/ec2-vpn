# EC2-VPN

A bash script to spin up an AWS EC2 instance and use it as a VPN.

:hammer: Work in progress :wrench:

This code assumes a lot of things about your set up but I am going to work on it
and make it a little more useful. I'll get round to writing a proper README
later this weekend in case people think this sort of thing could be useful.

## Okay but why?

I realised today that it's possible to set up a personal VPN using an
AWS EC2 instance so I went through the steps to set it up with OpenVPN.

Thing is though having an EC2 instance running all the time will end up costing
me money and I don't need to use a VPN all the time, but I also don't want to go
through the hassle of going into the AWS console and spinning up an instance,
then finding out which public IP I get and manually updating my `ovpn` file with
it when I need a VPN so I threw together this script to help me.

## What does it use?

Using `aws CLI`, `jq`, and `openvpn` it will query AWS for the state of my EC2
instance, spin it up, generate an `ovpn` file from a template that I have, then
connect my computer to it.

