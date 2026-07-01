# DeFi Market Intelligence Engine

A Rust based real time analytics engine for EVM onchain events and Hyperliquid market data. I'll making this project for educational purposes.

Core goals:
- Ingest EVM logs using JSON-RPC and WebSocket subscriptions
- Decode smart contract events into structured trade data
- Ingest Hyperliquid real time market streams
- Store high volume time series data in ClickHouse
- Store metadata and alert configuration in Postgres
- Use Redis for hot cache and live whale alerts
- Expose dashboards through Grafana and APIs

# Frequently used commands for the project

cargo check --workspace
cargo build --workspace
cargo run -p evm-indexer
cargo run -p hyperliquid-ingestor
cargo run -p analytics-worker
cargo run -p api-server
cargo test --workspace
cargo fmt --all
cargo clippy --workspace --all-targets
