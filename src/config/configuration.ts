/* eslint-disable @typescript-eslint/no-var-requires */
require('dotenv').config();

export const configuration = () => ({
  environment: process.env.NODE_ENV,
  port: process.env.PORT || 3000,
  host: 'localhost',
  queueBatchProcessingEnabled: false,
});