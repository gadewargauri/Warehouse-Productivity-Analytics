"""
Warehouse Productivity & Order Fulfillment Analytics
Run: pip install pandas numpy matplotlib seaborn
     python python/warehouse_analysis.py
"""
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "warehouse_orders.csv"
OUT = ROOT / "screenshots"
OUT.mkdir(exist_ok=True)

df = pd.read_csv(DATA)
print("Raw shape:", df.shape)
print("\nMissing values:\n", df.isna().sum())

# Cleaning
df["Order_Date"] = pd.to_datetime(df["Order_Date"], errors="coerce")
for col in ["Zone", "Picker_ID", "Priority"]:
    df[col] = df[col].fillna("Unknown")
numeric_cols = [
    "Items_Count", "Order_Lines", "Picking_Time_Min", "Packing_Time_Min",
    "Dispatch_Time_Min", "Queue_Delay_Min", "SLA_Min",
    "Total_Fulfillment_Time_Min", "On_Time_Flag"
]
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")
df = df.drop_duplicates(subset="Order_ID")
df = df.dropna(subset=["Order_Date", "Picking_Time_Min", "Packing_Time_Min"])

# KPI summary
total_orders = len(df)
on_time_rate = df["On_Time_Flag"].mean() * 100
avg_pick = df["Picking_Time_Min"].mean()
avg_pack = df["Packing_Time_Min"].mean()
avg_cycle = df["Total_Fulfillment_Time_Min"].mean()
print(f"\nTotal orders: {total_orders:,}")
print(f"On-time fulfillment: {on_time_rate:.1f}%")
print(f"Average picking time: {avg_pick:.1f} min")
print(f"Average packing time: {avg_pack:.1f} min")
print(f"Average fulfillment cycle: {avg_cycle:.1f} min")

# Aggregations for operational decisions
print("\nWarehouse performance:\n",
      df.groupby("Warehouse").agg(
          Orders=("Order_ID","count"),
          Avg_Picking=("Picking_Time_Min","mean"),
          Avg_Packing=("Packing_Time_Min","mean"),
          On_Time_Rate=("On_Time_Flag","mean")
      ).round(2))
print("\nBottlenecks by zone:\n",
      df.groupby("Zone").agg(
          Orders=("Order_ID","count"),
          Avg_Picking=("Picking_Time_Min","mean"),
          Avg_Packing=("Packing_Time_Min","mean"),
          Avg_Queue=("Queue_Delay_Min","mean")
      ).round(2).sort_values("Avg_Picking", ascending=False))
print("\nShift analysis:\n",
      df.groupby("Shift").agg(
          Orders=("Order_ID","count"),
          Avg_Cycle=("Total_Fulfillment_Time_Min","mean"),
          On_Time_Rate=("On_Time_Flag","mean")
      ).round(2))

# Charts
sns.set_theme(style="whitegrid")
plt.figure(figsize=(9,5))
sns.barplot(data=df, x="Warehouse", y="Picking_Time_Min", estimator="mean", errorbar=None)
plt.title("Average Picking Time by Warehouse")
plt.ylabel("Minutes")
plt.tight_layout()
plt.savefig(OUT/"avg_picking_by_warehouse.png", dpi=160)
plt.close()

monthly = df.set_index("Order_Date").resample("MS")["On_Time_Flag"].mean().mul(100).reset_index()
plt.figure(figsize=(10,5))
sns.lineplot(data=monthly, x="Order_Date", y="On_Time_Flag", marker="o")
plt.title("Monthly On-Time Fulfillment Rate")
plt.ylabel("On-time rate (%)")
plt.xlabel("Month")
plt.tight_layout()
plt.savefig(OUT/"monthly_on_time_rate.png", dpi=160)
plt.close()

stage = df[["Picking_Time_Min","Packing_Time_Min","Dispatch_Time_Min","Queue_Delay_Min"]].mean().sort_values(ascending=False)
plt.figure(figsize=(8,5))
sns.barplot(x=stage.values, y=stage.index)
plt.title("Average Time by Fulfillment Stage")
plt.xlabel("Average minutes")
plt.tight_layout()
plt.savefig(OUT/"fulfillment_stage_time.png", dpi=160)
plt.close()

print("\nCharts saved in screenshots/.")
