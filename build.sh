function configuration_setting() {
  echo "Start AWS Setting"
  if [ -z "$1" ]
  then
    echo "AWS Access Key Id was not found. Using configuration from previous step."
  else
    aws configure set aws_access_key_id "$INPUT_AWS_ACCESS_KEY_ID"
  fi

  if [ -z "$2" ]
  then
    echo "AWS Secret Access Key was not found. Using configuration from previous step."
  else
    aws configure set aws_secret_access_key "$INPUT_AWS_SECRET_ACCESS_KEY"
  fi

  if [ -z "$INPUT_AWS_REGION" ]
  then
    echo "AWS region not found. Using configuration from previous step."
  else
    aws configure set region "$INPUT_AWS_REGION"
  fi
}

function validate {
    if [ -z "$INPUT_S3_FOLDER" ] || [ -z "$INPUT_SOURCE" ]
      then
        echo "Error: Requires source and s3 folder"
        exit 1
    fi
}

function uploadFromLocalFile() {
    aws --version
    aws s3 cp --recursive ./src/$INPUT_SOURCE/ s3://$INPUT_S3_FOLDER || { echo "Error downloading files from S3"; exit 1; }
}

function uploadFromS3() {
      echo "Source: "$INPUT_SOURCE
      echo "Target: "$INPUT_S3_FOLDER

      aws --version
      mkdir tmp
      aws s3 cp --recursive s3://$INPUT_SOURCE tmp || { echo "Error downloading files from S3"; exit 1; }
      configuration_setting $INPUT_TARGET_AWS_ACCESS_KEY_ID $INPUT_TARGET_AWS_SECRET_ACCESS_KEY
      aws s3 cp --recursive ./tmp/ s3://$INPUT_S3_FOLDER || { echo "Error uploading files to S3"; exit 1; }
}

function main {
  configuration_setting $INPUT_AWS_ACCESS_KEY_ID $INPUT_AWS_SECRET_ACCESS_KEY
  validate

  if [[ "$INPUT_UPLOAD_FROM" == "S3" ]]; then
    uploadFromS3
  else
    uploadFromLocalFile
  fi



  # aws cloudfront create-invalidation --distribution-id $INPUT_CLOUDFRONT_ID --paths /$INPUT_SOURCE/*

}

main