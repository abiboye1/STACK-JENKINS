terraform{
         backend "s3"{
                bucket= "stackbuckstateabib-automation"
                key = "NEW_CLIXX_EC2.tfsate"
                region="us-east-1"
                dynamodb_table="statelock-tf"
                 }
 }