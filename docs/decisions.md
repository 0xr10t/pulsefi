Decision 1: Use ClickHouse for raw market data because it is append heavy and analytical.
Decision 2: Use Postgres for metadata because it needs relational consistency.
Decision 3: Use Redis for latest alerts and pub/sub because it is low latency.
Decision 4: Start with Uniswap V3 Swap events before indexing complex protocols.
