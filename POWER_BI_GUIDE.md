# Power BI Dashboard Guide

## Import
1. Open Power BI Desktop.
2. Get Data → Text/CSV → `data/warehouse_orders.csv`.
3. Set `Order_Date` to Date; time and count fields to Whole/Decimal Number as appropriate.
4. In Power Query, replace null `Zone`, `Picker_ID`, and `Priority` with `Unknown`.
5. Create a date table and relate `Date[Date]` to `warehouse_orders[Order_Date]`.

## Suggested report pages
### Page 1 — Executive Overview
Cards: Total Orders, On-Time Rate, Average Fulfillment Time, Average Picking Time.
Visuals: Orders by warehouse, monthly on-time rate, fulfillment time by stage.
Slicers: Date, Warehouse, Shift, Order Type, Priority.

### Page 2 — Productivity
Visuals: Average picking time by warehouse and zone; orders handled by picker;
average picking time vs items count; shift-wise productivity.
Slicers: Warehouse, Zone, Shift, Picker.

### Page 3 — Fulfillment Bottlenecks
Visuals: Queue delay by zone, delayed orders by order type, SLA status,
average time by fulfillment stage.
Use conditional formatting to highlight high average times and low on-time rates.

## DAX measures
```DAX
Total Orders =
COUNTROWS(warehouse_orders)

On-Time Orders =
CALCULATE(
    COUNTROWS(warehouse_orders),
    warehouse_orders[On_Time_Flag] = 1
)

On-Time Fulfillment % =
DIVIDE([On-Time Orders], [Total Orders], 0)

Delayed Orders =
CALCULATE(
    COUNTROWS(warehouse_orders),
    warehouse_orders[Fulfillment_Status] = "Delayed"
)

Delay Rate % =
DIVIDE([Delayed Orders], [Total Orders], 0)

Average Picking Time =
AVERAGE(warehouse_orders[Picking_Time_Min])

Average Packing Time =
AVERAGE(warehouse_orders[Packing_Time_Min])

Average Fulfillment Time =
AVERAGE(warehouse_orders[Total_Fulfillment_Time_Min])

Average Queue Delay =
AVERAGE(warehouse_orders[Queue_Delay_Min])

Orders per Picker =
DIVIDE(
    [Total Orders],
    DISTINCTCOUNT(warehouse_orders[Picker_ID]),
    0
)
```

## Important
The dataset is synthetic and created for portfolio practice. Clearly label it as synthetic in the report and README. Do not present the generated values as real warehouse performance.
