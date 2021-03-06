# configuration for Elasticsearch resources

config:
  # ES indexer bolt
  es.indexer.addresses: "${ES_ADDRESS}"
  es.indexer.index.name: "results"
  es.indexer.doc.type: "doc"
  es.indexer.create: false
  es.indexer.flushInterval: "1s"
  es.indexer.settings:
    cluster.name: "elasticsearch"

  # ES metricsConsumer
  es.metrics.addresses: "${ES_ADDRESS}"
  es.metrics.index.name: "metrics"
  es.metrics.doc.type: "datapoint"
  es.metrics.settings:
    cluster.name: "elasticsearch"

  # ES spout and persistence bolt
  es.status.addresses: "${ES_ADDRESS}"
  es.status.index.name: "crawlstatus-*"
  es.status.doc.type: "status"
  # the routing is done on the value of 'partition.url.mode'
  es.status.routing: true
  # stores the value used for the routing as a separate field
  # needed by the spout implementations
  es.status.routing.fieldname: "metadata.hostname"
  es.status.bulkActions: 500
  es.status.flushInterval: "1s"
  es.status.concurrentRequests: 5
  es.status.settings:
    cluster.name: "elasticsearch"

  ################
  # spout config #
  ################

  # time in secs for which the URLs will be considered for fetching after a ack of fail
  es.status.ttl.purgatory: 30

  # Min time (in msecs) to allow between 2 successive queries to ES
  es.status.min.delay.queries: 2000

  es.status.max.buckets: 250
  es.status.max.urls.per.bucket: 4
  # field to group the URLs into buckets
  es.status.bucket.field: "metadata.hostname"
  # field to sort the URLs within a bucket
  es.status.bucket.sort.field: "nextFetchDate"
  # field to sort the buckets
  es.status.global.sort.field: "nextFetchDate"

  # Delay since previous query date (in secs) after which the nextFetchDate value will be reset
  es.status.reset.fetchdate.after: 180

  # CollapsingSpout : limits the deep paging by resetting the start offset for the ES query
  es.status.max.start.offset: 500

  # AggregationSpout : sampling improves the performance on large crawls
  es.status.sample: true

  # es.status.recentDate.increase: 10
  # es.status.recentDate.min.gap: 2

  topology.metrics.consumer.register:
       - class: "com.digitalpebble.stormcrawler.elasticsearch.metrics.MetricsConsumer"
         parallelism.hint: 1
         #whitelist:
         #  - "fetcher_counter"
         #  - "fetcher_average.bytes_fetched"
         #blacklist:
         #  - "__receive.*"
