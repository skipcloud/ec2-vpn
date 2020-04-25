# this awk script just replaces the IP in an ovpn file
# with REMOTE_IP

$1 == "remote" {
  $2="REMOTE_IP" 
  print 
}

$1 != "remote" { print }
