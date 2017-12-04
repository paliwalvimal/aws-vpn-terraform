# aws-vpn-terraform
Build your own VPN server in less than 5 minutes at any of the 16 regions of AWS

<strong>Prerequisites:</strong>
<ul>
  <li>AWS Account</li>
  <li>IAM User with Access Key & Secret Key</li>
  <li>AWS CLI (<a target="_blank" href="https://aws.amazon.com/cli/">Download</a>)</li>
  <li>Terraform (<a target="_blank" href="https://www.terraform.io/downloads.html">Download</a>)</li>
</ul>

<strong>1. Configure local machine:</strong>
<ul>
  <li>Install AWS CLI</li>
  <li>Open terminal(linux/mac)/command prompt(windows)</li>
  <li>Run <code>aws configure</code></li>
  <li>Provide the access key, secret key and region as requested</li>
</ul>

<strong>2. Setup VPN Server:</strong>
<ul>
  <li>Unzip downloaded terraform file</li>
  <li>Add terraform executable file to your environment variable (Optional)</li>
  <li>Download main.tf, variables.tf, private-key.ppk, public-key and user-data.txt files. <strong>Note: You can generate your own private & public key</strong></li>
  <li>Open terminal(linux)/command prompt(windows)</li>
  <li>Run <code>terraform init</code> command</li>
  <li>Run <code>terraform apply</code> command. Provide <strong>yes</strong> as input if asked and hit enter to start the process of setting up your own private VPN server</li>
</ul>

<h2><strong>Hurray!! VPN server is now successfully up and running</strong></h2>

<p>3. Few Changes:</p>
<ul>
  <li>Go to https://public-ip/admin</li>
  <li>Enter <strong>openvpn</strong> as username and <strong>openvpnpass</strong> as password</li>
  <li>Under Configuration click on VPN Settings</li>
  <li>Under Routing change both the last questions to <strong>yes</strong></li>
  <li>Under "DNS Settings" select <strong>second option</strong> for first question</li>
</ul>

<h2><strong>You can now go to https://public-ip and start enjoying VPC service</strong></h2>
