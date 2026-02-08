###### **Price History Collector (REST API → SQL Server)**

A lightweight ETL solution built with PowerShell to collect price data from a REST API and build a historical dataset in SQL Server.



**Problem**
The API only exposes current prices and does not provide historical data.



**Solution**

* Poll the API every 10 minute
* Detect price changes
* Normalize Persian fields
* Persist historical records in SQL Server
* Prevent duplicate inserts



###### **Architecture**

REST API → PowerShell ETL → SQL Server (PriceHistory)



###### **Automation**

Executed every 10 minute via SQL Server Agent Job.



###### **Database Design**

* Separate source update time and insert time
* UTC-based timestamps
* Optimized for time-series data



###### **Technologies**

* PowerShell
* REST API
* SQL Server
* SQL Server Agent



###### **Security**

Sensitive values (API keys, URLs, connection strings) are excluded.



**The PowerShell script is intentionally kept simple, as it was designed for reliability and frequent execution in a production environment.**

