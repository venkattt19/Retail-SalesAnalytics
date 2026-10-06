import pandas as pd
import pyodbc

# Load the CSV file
df = pd.read_csv("RetailSales.csv")

# Connect to SQL Server
conn = pyodbc.connect(
    "DRIVER={SQL Server};"
    "SERVER=DESKTOP-01\\SQLEXPRESS;"
    "DATABASE=RetailSalesDB;"
    "Trusted_Connection=yes;"
)

cursor = conn.cursor()

# Insert data into the RetailSales table
for _, row in df.iterrows():
    cursor.execute("""
        INSERT INTO RetailSales (
            Order_ID, Order_Date, Ship_Date, Ship_Mode,
            Customer_ID, Customer_Name, Segment, Country,
            City, State, Region, Product_ID,
            Category, Sub_Category, Product_Name,
            Sales, Quantity, Discount, Profit
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """,
    row["Order_ID"],
    row["Order_Date"],
    row["Ship_Date"],
    row["Ship_Mode"],
    row["Customer_ID"],
    row["Customer_Name"],
    row["Segment"],
    row["Country"],
    row["City"],
    row["State"],
    row["Region"],
    row["Product_ID"],
    row["Category"],
    row["Sub_Category"],
    row["Product_Name"],
    row["Sales"],
    row["Quantity"],
    row["Discount"],
    row["Profit"]
    )

conn.commit()
conn.close()

print("Data imported successfully!")