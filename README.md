# Warehouse Productivity & Order Fulfillment Analytics

An end-to-end Data Analyst portfolio project using **Python, SQL, Excel and Power BI** to evaluate warehouse picking, packing, dispatch, queue delays and order fulfillment performance.

## Business problem
Warehouse managers need to understand where time is being spent between order receipt and dispatch. This project turns order-level operational data into KPIs that help identify bottlenecks, compare warehouse performance and monitor service-level achievement.

## Project objectives
- Measure average picking, packing, dispatch and queue delay times.
- Calculate order fulfillment cycle time and on-time fulfillment rate.
- Compare performance by warehouse, zone, shift, order type and picker.
- Identify bottlenecks and operational improvement opportunities.

## Tools
- Python: Pandas, NumPy, Matplotlib, Seaborn
- SQL: aggregations, joins-ready structure, CTEs, CASE, window functions, views
- Excel: formulas, KPI summary, charts and raw-data table
- Power BI: Power Query, DAX measures, slicers and multi-page dashboard

## Repository structure
```text
Warehouse_Productivity_Order_Fulfillment_Analytics/
├── data/
│   └── warehouse_orders.csv
├── python/
│   └── warehouse_analysis.py
├── sql/
│   └── warehouse_analysis.sql
├── excel/
│   └── warehouse_productivity_dashboard.xlsx
├── powerbi/
│   └── POWER_BI_GUIDE.md
├── screenshots/
├── requirements.txt
└── README.md
```

## Dataset
`data/warehouse_orders.csv` contains 2,500 synthetic order records covering six months. Fields include:
- Order and date identifiers
- Warehouse, zone, shift and picker
- Order type, priority, item count and order lines
- Picking, packing, dispatch and queue delay minutes
- SLA target, total fulfillment time and on-time status

**Data notice:** This is a simulated dataset generated for learning and portfolio demonstration. It is not sourced from a real company or warehouse. The analysis and conclusions are illustrative.

## How to run the Python analysis
From the project root:

```bash
pip install -r requirements.txt
python python/warehouse_analysis.py
```

The script prints KPI and segment summaries and saves charts in `screenshots/`.

## How to use the Excel dashboard
Open `excel/warehouse_productivity_dashboard.xlsx`. The `Dashboard` sheet contains formula-driven KPI summaries and charts. The `Orders_Data` sheet contains the underlying order-level records. In Excel, allow formulas to recalculate when prompted.

## How to build the Power BI report
Follow `powerbi/POWER_BI_GUIDE.md` to import the CSV, clean fields in Power Query, create DAX measures and build the three report pages.

A `.pbix` file is not included because it must be authored and saved in Power BI Desktop. Add your finished `.pbix` file and dashboard screenshots to this repository after building the report.

## SQL analysis
Run `sql/warehouse_analysis.sql` after importing the CSV into a table named `warehouse_orders`. The queries cover overall KPIs, warehouse and zone comparisons, bottleneck stages, order-type delays, picker productivity, shift comparisons and a reporting view.

## Key questions answered
1. Which warehouse has the slowest average picking time?
2. Which fulfillment stage consumes the most time?
3. Which zones experience the largest queue delays?
4. How does on-time fulfillment vary by shift and order type?
5. Which operational segments should managers investigate first?

## Business recommendations to investigate
- Review slotting and item placement in zones with high picking times.
- Examine staffing and workload balance for shifts with lower on-time rates.
- Investigate queue buildup before dispatch.
- Compare express and bulk workflows separately because their SLA targets differ.
- Monitor stage-level KPIs weekly rather than relying only on total cycle time.

**Warehouse Productivity & Order Fulfillment Analytics | Python, SQL, Excel, Power BI**
- Analyzed 2,500 simulated warehouse orders using Python and SQL to measure picking, packing, dispatch and queue performance.
- Developed an Excel KPI dashboard and designed a Power BI reporting solution to monitor fulfillment time, on-time rate and warehouse productivity.
- Used CTEs, window functions, aggregations and operational segmentation to identify potential bottlenecks across warehouses, zones and shifts.

