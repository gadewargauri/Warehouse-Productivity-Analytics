-- Warehouse Productivity & Order Fulfillment Analytics
-- Assumption: warehouse_orders is loaded from data/warehouse_orders.csv.
-- SQL syntax is PostgreSQL-friendly.

-- 1. Overall operational KPIs
SELECT
    COUNT(*) AS total_orders,
    ROUND(AVG(picking_time_min)::numeric, 2) AS avg_picking_min,
    ROUND(AVG(packing_time_min)::numeric, 2) AS avg_packing_min,
    ROUND(AVG(total_fulfillment_time_min)::numeric, 2) AS avg_fulfillment_min,
    ROUND(100.0 * AVG(on_time_flag), 2) AS on_time_rate_pct
FROM warehouse_orders;

-- 2. Warehouse-level performance
SELECT warehouse, COUNT(*) AS orders,
       ROUND(AVG(picking_time_min)::numeric,2) AS avg_picking_min,
       ROUND(AVG(packing_time_min)::numeric,2) AS avg_packing_min,
       ROUND(100.0*AVG(on_time_flag),2) AS on_time_rate_pct
FROM warehouse_orders
GROUP BY warehouse
ORDER BY on_time_rate_pct ASC;

-- 3. Identify bottleneck fulfillment stage (average minutes)
SELECT 'Picking' AS stage, ROUND(AVG(picking_time_min)::numeric,2) AS avg_minutes FROM warehouse_orders
UNION ALL
SELECT 'Packing', ROUND(AVG(packing_time_min)::numeric,2) FROM warehouse_orders
UNION ALL
SELECT 'Dispatch', ROUND(AVG(dispatch_time_min)::numeric,2) FROM warehouse_orders
UNION ALL
SELECT 'Queue', ROUND(AVG(queue_delay_min)::numeric,2) FROM warehouse_orders
ORDER BY avg_minutes DESC;

-- 4. Zone-level bottlenecks
SELECT zone, COUNT(*) AS orders,
       ROUND(AVG(picking_time_min)::numeric,2) AS avg_picking_min,
       ROUND(AVG(queue_delay_min)::numeric,2) AS avg_queue_min
FROM warehouse_orders
GROUP BY zone
ORDER BY avg_picking_min DESC;

-- 5. CTE: delayed orders by order type
WITH order_type_kpis AS (
    SELECT order_type, COUNT(*) AS total_orders,
           SUM(CASE WHEN fulfillment_status='Delayed' THEN 1 ELSE 0 END) AS delayed_orders
    FROM warehouse_orders
    GROUP BY order_type
)
SELECT order_type, total_orders, delayed_orders,
       ROUND(100.0*delayed_orders/NULLIF(total_orders,0),2) AS delay_rate_pct
FROM order_type_kpis
ORDER BY delay_rate_pct DESC;

-- 6. Window function: rank warehouse by picking speed
SELECT warehouse, avg_picking_min,
       DENSE_RANK() OVER (ORDER BY avg_picking_min ASC) AS picking_speed_rank
FROM (
    SELECT warehouse, AVG(picking_time_min) AS avg_picking_min
    FROM warehouse_orders
    GROUP BY warehouse
) w;

-- 7. Daily order volume and on-time rate
SELECT order_date, COUNT(*) AS orders,
       ROUND(100.0*AVG(on_time_flag),2) AS on_time_rate_pct
FROM warehouse_orders
GROUP BY order_date
ORDER BY order_date;

-- 8. Picker productivity
SELECT picker_id, COUNT(*) AS orders_handled,
       ROUND(AVG(picking_time_min)::numeric,2) AS avg_picking_min,
       ROUND(100.0*AVG(on_time_flag),2) AS on_time_rate_pct
FROM warehouse_orders
WHERE picker_id <> 'Unknown'
GROUP BY picker_id
HAVING COUNT(*) >= 10
ORDER BY orders_handled DESC;

-- 9. Priority and shift comparison
SELECT shift, priority, COUNT(*) AS orders,
       ROUND(AVG(total_fulfillment_time_min)::numeric,2) AS avg_cycle_min,
       ROUND(100.0*AVG(on_time_flag),2) AS on_time_rate_pct
FROM warehouse_orders
GROUP BY shift, priority
ORDER BY shift, priority;

-- 10. View for Power BI
CREATE OR REPLACE VIEW vw_warehouse_performance AS
SELECT order_id, order_date, warehouse, zone, shift, picker_id,
       order_type, priority, items_count, order_lines,
       picking_time_min, packing_time_min, dispatch_time_min,
       queue_delay_min, sla_min, total_fulfillment_time_min,
       fulfillment_status, on_time_flag
FROM warehouse_orders;
