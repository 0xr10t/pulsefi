EVM RPC Node
  -> evm-indexer
  -> ClickHouse raw_evm_logs / decoded_evm_swaps

Hyperliquid WebSocket
  -> hyperliquid-ingestor
  -> ClickHouse hyperliquid_trades

ClickHouse
  -> analytics-worker
  -> whale alerts

Postgres
  -> metadata, checkpoints, alert rules

Redis
  -> latest alerts, cache, pub/sub

api-server
  -> dashboards / clients