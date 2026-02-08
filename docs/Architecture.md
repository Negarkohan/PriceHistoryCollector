## Architecture Overview

This solution periodically calls the API to build historical data, since the API does not provide it.

- PowerShell acts as a lightweight ETL layer
- SQL Server stores historical price snapshots
- SQL Server Agent ensures reliable execution

Designed for production environments where simplicity and reliability matter.
