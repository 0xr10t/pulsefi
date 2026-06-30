# Project Learning Notes

Notes on Rust dependencies used in PulseFi — what each crate does and why it is here.

---

## Async Runtime

### `tokio`

Async runtime for Rust.

- `#[tokio::main]` transforms a normal `main` into one that creates a Tokio runtime and runs async code inside it.
- Modular by design — enable only the features you need, or use `features = ["full"]` for everything.

**Used in:** all crates (workspace dependency)

---

## Error Handling

### `anyhow`

Simple error handling for application code.

Normally Rust errors look like `Result<String, std::io::Error>`. With `anyhow`, any error type converts into one common error type. Attach context with `anyhow::Context`.

```rust
use anyhow::{Context, Result};

fn read_config(path: &str) -> Result<String> {
    std::fs::read_to_string(path).context("failed to read config file")
}
```

**Used in:** all crates (workspace dependency)

### `thiserror`

Derive macro for custom error types in libraries.

Instead of manually implementing `Display` and `Error`:

```rust
use thiserror::Error;

#[derive(Error, Debug)]
enum MyError {
    #[error("file not found")]
    File,

    #[error("invalid number")]
    Parse,
}
```

Rust automatically implements `Display`, `Error`, and `Debug`.

**Used in:** workspace (available for `common` and library-style error types)

---

## Serialization

### `serde`

Framework for converting Rust structs into many formats:

- JSON
- YAML
- TOML
- MessagePack
- BSON
- and more

Serde defines the serialization traits; format-specific crates (like `serde_json`) provide the implementations.

**Used in:** all crates (workspace dependency)

### `serde_json`

JSON implementation for Serde.

- **Serde** = framework
- **serde_json** = JSON backend

**Used in:** all crates (workspace dependency)

---

## Logging

### `tracing`

Structured logging.

Instead of:

```rust
println!("User logged in");
```

Use log levels:

```rust
tracing::info!("User logged in");
tracing::warn!("Low balance");
tracing::error!("Database failed");
```

Different levels make it easy to filter output. Attach structured fields:

```rust
tracing::info!(
    user = "Alice",
    balance = 120,
    "Payment processed"
);
```

**Used in:** all crates (workspace dependency)

### `tracing-subscriber`

`tracing` creates log events; the subscriber displays them (stdout, JSON, filtering, etc.).

**Used in:** all crates (workspace dependency)

---

## Configuration

### `config`

Load settings from files instead of hardcoding values.

```toml
# config.toml
host = "localhost"
port = 8080
```

Can merge multiple sources:

- TOML
- YAML
- JSON
- environment variables

**Used in:** workspace dependency (available when needed)

### `dotenvy`

Reads environment variables from a `.env` file at startup.

**Used in:** all crates (workspace dependency)

---

## Blockchain

### `ethers`

Connect to Ethereum-compatible chains.

```rust
let provider = Provider::<Http>::try_from("https://eth.llamarpc.com")?;
let block = provider.get_block_number().await?;
```

**Used in:** `evm-indexer`

---

## Databases

### `clickhouse`

Client for ClickHouse — high-volume time-series and analytical queries.

```rust
client.insert("transactions", ...)?;
client.query("SELECT * FROM blocks").fetch_all().await?;
```

**Used in:** `evm-indexer`, `hyperliquid-ingestor`, `analytics-worker`, `api-server`

### `sqlx`

Async SQL database access.

| Feature | Purpose |
|---------|---------|
| `runtime-tokio` | Uses Tokio for async I/O |
| `postgres` | PostgreSQL driver |
| `tls-rustls` | Encrypted connections via Rustls (not OpenSSL) |

**Used in:** `evm-indexer`, `analytics-worker`, `api-server`

### `redis`

Connect to Redis for hot cache, pub/sub, and low-latency alerts.

**Used in:** `analytics-worker`, `api-server`

---

## Networking

### `tokio-tungstenite`

WebSocket client/server on top of Tokio.

```rust
let (stream, _) = connect_async(url).await?;
// receive messages continuously
```

**Used in:** `hyperliquid-ingestor`

### `futures-util`

Async utilities — the async equivalent of iterator helpers (`StreamExt`, `SinkExt`, etc.).

**Used in:** `hyperliquid-ingestor`

---

## Web API

### `axum`

Web framework for building REST APIs (similar role to Express in Node.js).

**Used in:** `api-server`

### `tower-http`

HTTP middleware for Axum/Tower stacks.

```
Client
  ↓
Middleware  (logging, CORS, compression, static files, security headers)
  ↓
Handler
```

**Used in:** `api-server`
