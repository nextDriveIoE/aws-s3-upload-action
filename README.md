# AWS S3 Upload Action

```shell
        uses: nextDriveIoE/aws-s3-upload-action@main
        with:
          s3_folder: 'cems'
          source: 'cems'
          aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws_region: 'ap-northeast-1'
```