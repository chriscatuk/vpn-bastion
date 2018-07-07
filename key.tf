# Define the Key Pair you will add in AWS
# It must not exist before running the script

resource "aws_key_pair" "key" {
   key_name   = "${var.keyname}"
   public_key = "${var.keypublic}"
}