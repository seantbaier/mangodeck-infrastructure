variable "batch_size" {
  description = "(Optional) The largest number of records that Lambda will retrieve from your event source at the time of invocation. Defaults to 100 for DynamoDB, Kinesis, MQ and MSK, 10 for SQS."
  type        = number
  default     = null
}

variable "event_source_arn" {
  description = "(Optional) The event source ARN - this is required for Kinesis stream, DynamoDB stream, SQS queue, MQ broker or MSK cluster. It is incompatible with a Self Managed Kafka source."
  type        = string
  default     = null
}

variable "function_name" {
  description = "(Required) The name or the ARN of the Lambda function that will be subscribing to events."
  type        = string
}

variable "function_response_types" {
  description = "(Optional) A list of current response type enums applied to the event source mapping for AWS Lambda checkpointing. Only available for stream sources (DynamoDB and Kinesis). Valid values: ReportBatchItemFailures."
  type        = string
  default     = null
}


# bisect_batch_on_function_error: - (Optional) If the function returns an error, split the batch in two and retry. Only available for stream sources (DynamoDB and Kinesis). Defaults to false.
# destination_config: - (Optional) An Amazon SQS queue or Amazon SNS topic destination for failed records. Only available for stream sources (DynamoDB and Kinesis). Detailed below.
# enabled - (Optional) Determines if the mapping will be enabled on creation. Defaults to true.
# maximum_batching_window_in_seconds - (Optional) The maximum amount of time to gather records before invoking the function, in seconds (between 0 and 300). Records will continue to buffer (or accumulate in the case of an SQS queue event source) until either maximum_batching_window_in_seconds expires or batch_size has been met. For streaming event sources, defaults to as soon as records are available in the stream. If the batch it reads from the stream/queue only has one record in it, Lambda only sends one record to the function. Only available for stream sources (DynamoDB and Kinesis) and SQS standard queues.
# maximum_record_age_in_seconds: - (Optional) The maximum age of a record that Lambda sends to a function for processing. Only available for stream sources (DynamoDB and Kinesis). Must be either -1 (forever, and the default value) or between 60 and 604800 (inclusive).
# maximum_retry_attempts: - (Optional) The maximum number of times to retry when the function returns an error. Only available for stream sources (DynamoDB and Kinesis). Minimum and default of -1 (forever), maximum of 10000.
# parallelization_factor: - (Optional) The number of batches to process from each shard concurrently. Only available for stream sources (DynamoDB and Kinesis). Minimum and default of 1, maximum of 10.
# queues - (Optional) The name of the Amazon MQ broker destination queue to consume. Only available for MQ sources. A single queue name must be specified.
# self_managed_event_source: - (Optional) For Self Managed Kafka sources, the location of the self managed cluster. If set, configuration must also include source_access_configuration. Detailed below.
# source_access_configuration: (Optional) For Self Managed Kafka sources, the access configuration for the source. If set, configuration must also include self_managed_event_source. Detailed below.
# starting_position - (Optional) The position in the stream where AWS Lambda should start reading. Must be one of AT_TIMESTAMP (Kinesis only), LATEST or TRIM_HORIZON if getting events from Kinesis, DynamoDB or MSK. Must not be provided if getting events from SQS. More information about these positions can be found in the AWS DynamoDB Streams API Reference and AWS Kinesis API Reference.
# starting_position_timestamp - (Optional) A timestamp in RFC3339 format of the data record which to start reading when using starting_position set to AT_TIMESTAMP. If a record with this exact timestamp does not exist, the next later record is chosen. If the timestamp is older than the current trim horizon, the oldest available record is chosen.
# topics - (Optional) The name of the Kafka topics. Only available for MSK sources. A single topic name must be specified.
# tumbling_window_in_seconds - (Optional) The duration in seconds of a processing window for AWS Lambda streaming analytics. The range is between 1 second up to 900 seconds. Only available for stream sources (DynamoDB and Kinesis).
