import * as AWS from 'aws-sdk';
import * as dotenv from 'dotenv';
dotenv.config();

interface INcloudStorageConfig {
  endpoint: string;
  region: string;
  accessKey: string;
  secretKey: string;
  bucketName: string;
}

class NcloudStorageConfig implements INcloudStorageConfig {
  endpoint: string;
  region: string;
  accessKey: string;
  secretKey: string;
  bucketName: string;
  constructor() {
    this.endpoint = process.env.NCLOUD_ENDPOINT;
    this.region = process.env.NCLOUD_REGION;
    this.accessKey = process.env.NCLOUD_ACCESS_KEY;
    this.secretKey = process.env.NCLOUD_SECRET_KEY;
    this.bucketName = process.env.BUCKET_NAME;
  }

  getConfig() {
    return {
      endpoint: this.endpoint,
      region: this.region,
      credentials: {
        accessKeyId: this.accessKey,
        secretAccessKey: this.secretKey,
      },
    };
  }
}

export const S3 = new AWS.S3(new NcloudStorageConfig().getConfig());
export const bucketName = process.env.BUCKET_NAME;
export const endpoint = process.env.NCLOUD_ENDPOINT;
