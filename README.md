```markdown
# Snowflake TPC-H Sales Analysis

A SQL analysis of the TPC-H sample dataset (~1.5M order line items) run in
Snowflake, answering common commercial questions about customers, revenue
trends, and revenue concentration.

## Key findings
- **Revenue is concentrated:** the top 5% of orders account for ~X% of total revenue.
- **BUILDING is the largest segment** by revenue, with an average order value of $151029.44.
- Revenue by year: From 1992 to 1997, the sales grew steadily, while in 1998, the sales dropped.

## What this demonstrates
- Snowflake (cloud data warehouse): navigating databases/schemas, querying at scale
- SQL: multi-table joins, aggregations, date functions, window functions (NTILE)

## How to reproduce
1. Any Snowflake account has `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1` available by default.
2. Run the queries in `analysis.sql` in a worksheet.

## Tools
Snowflake · SQL
```
