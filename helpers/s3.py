import boto3
import configs

s3_client = boto3.client('s3')


def get_object(key: str):
    try:
        obj = s3_client.get_object(
            Bucket=configs.S3_BUCKET_NAME,
            Key=key
        )
        return obj['Body'].read().decode()  # StreamingBody -> bytes -> str
    except Exception as e:
        return ''


def put_object(key, body):
    if type(body) == str:
        body = body.encode()

    try:
        return s3_client.put_object(
            ACL='private',
            Body=body,
            Bucket=configs.S3_BUCKET_NAME,
            Key=key,
        )
    except Exception as e:
        print(e)
        return None
