resource "aws_key_pair" "deployer" {
  key_name   = "jazz-key"
  public_key = "${file("ssh_keys/jazz.pub")}"
}
