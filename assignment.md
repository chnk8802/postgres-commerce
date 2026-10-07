# PostgreSQL Technical Assignment

**Position:** Full-Stack Developer  
**Assessment Area:** PostgreSQL / Relational Database Engineering  
**Recommended Time:** 10–15 hours  
**Submission:** SQL files + README  
**Difficulty:** Junior–Mid-Level Full-Stack Developer

---

# 1. Background

Our company is developing an internal **Commerce & Order Management System**.

The application allows customers to purchase products from different categories. The system must manage customers, addresses, products, inventory, orders, payments and product reviews.

Your task is to design and implement the **PostgreSQL database layer**.

You are **not required to build a frontend or backend API**.

We want to evaluate your ability to:

- Design relational databases
- Model relationships correctly
- Write SQL queries
- Maintain data integrity
- Work with PostgreSQL features
- Handle transactions
- Design indexes
- Analyze query performance
- Solve realistic data problems

---

# 2. Business Requirements

The system must support the following entities.

### Customers

Store:

- Customer ID
- Full name
- Email
- Phone number
- Account status
- Created date
- Updated date

Emails must be unique.

A customer can have multiple addresses.

---

### Addresses

Store:

- Address ID
- Customer ID
- Address type
- Address line
- City
- State
- Postal code
- Country
- Whether it is the customer's default address

Address types may include:

- HOME
- WORK
- OTHER

---

### Categories

Products belong to categories.

Categories must support hierarchy.

Example:

Electronics  
→ Computers  
→ Laptops

Store:

- Category ID
- Category name
- Parent category
- Created date

---

### Products

Store:

- Product ID
- Product name
- Description
- SKU
- Price
- Category
- Product status
- Additional product attributes
- Created date
- Updated date

SKU must be unique.

Additional attributes should be stored using PostgreSQL `JSONB`.

Example:

```json
{
  "brand": "ExampleTech",
  "color": "Black",
  "warranty_months": 24
}
```

---

# 3. Inventory

Each product must have inventory information.

Store:

- Product ID
- Available quantity
- Reserved quantity
- Last updated date

Inventory quantities must never become negative.

---

# 4. Orders

Customers can place orders containing multiple products.

Store order-level information including:

- Order ID
- Customer ID
- Shipping address
- Order status
- Total amount
- Created date
- Updated date

Possible statuses:

- PENDING
- CONFIRMED
- SHIPPED
- DELIVERED
- CANCELLED

---

# 5. Order Items

Each order can contain multiple products.

Store:

- Order item ID
- Order ID
- Product ID
- Quantity
- Unit price
- Discount amount

**Important requirement:**

The price stored in an order item must represent the price the customer paid **when the order was placed**.

Changing the current product price must not change historical orders.

---

# 6. Payments

An order may have one or more payment attempts.

Store:

- Payment ID
- Order ID
- Payment method
- Amount
- Payment status
- Transaction reference
- Payment timestamp

Payment methods may include:

- UPI
- CARD
- NET_BANKING
- COD

Payment statuses:

- PENDING
- SUCCESS
- FAILED
- REFUNDED

Transaction references must be unique when present.

---

# 7. Product Reviews

Customers can review products they have purchased.

Store:

- Review ID
- Customer ID
- Product ID
- Rating
- Review text
- Created date

Rating must be between **1 and 5**.

A customer may submit only **one review per product**.

---

# PART A — DATABASE DESIGN

Create the complete database schema.

Your schema should demonstrate appropriate use of:

- Primary keys
- Foreign keys
- `NOT NULL`
- `UNIQUE`
- `CHECK`
- `DEFAULT`
- Appropriate PostgreSQL data types
- `ON DELETE` behaviour
- Timestamps

You must decide:

- Which relationships are one-to-one
- Which are one-to-many
- Which are many-to-many
- Which columns should allow NULL
- Appropriate deletion behaviour
- Appropriate numeric types for monetary values

### Deliverable

Create:

`01_schema.sql`

Also include a short explanation of your schema design in the README.

---

# PART B — SAMPLE DATA

Create enough realistic data to properly test your queries.

Minimum:

- 20 customers
- 5 categories
- 30 products
- 40 orders
- 80 order items
- Multiple payment attempts
- Product reviews
- Inventory for every product

Make sure the data includes edge cases such as:

- Customer with no orders
- Product with no sales
- Failed payment
- Cancelled order
- Product with zero inventory
- Customer with multiple addresses
- Product with multiple reviews

### Deliverable

`02_seed_data.sql`

---

# PART C — SQL QUERY CHALLENGES

Write SQL queries for the following requirements.

### Query 1

Return all active products with:

- Product name
- Category
- Price
- Available inventory

Sort from highest price to lowest.

---

### Query 2

Return complete order details for a given order ID.

Include:

- Customer
- Order information
- Products
- Quantity
- Unit price
- Discount
- Payment status

---

### Query 3

Find customers who have **never placed an order**.

---

### Query 4

Find products that have **never been ordered**.

---

### Query 5

Calculate total revenue generated by each product.

Return:

- Product
- Units sold
- Revenue

Do not count cancelled orders.

---

### Query 6

Find the **top 5 customers by total spending**.

Return:

- Customer
- Number of orders
- Total amount spent
- Average order value

---

### Query 7

Calculate monthly revenue for the previous 12 months.

Return:

- Month
- Number of orders
- Revenue

---

### Query 8

Find products whose price is greater than the **average product price of their category**.

---

### Query 9

Find customers who have placed at least **3 completed orders**.

---

### Query 10

Find orders where the payment total does not match the order total.

Consider only successful payments.

---

# PART D — ADVANCED SQL

### Challenge 1 — Window Functions

For every category, return the **top 3 products by revenue**.

You are expected to use a window function.

---

### Challenge 2 — Customer Ranking

Rank customers according to their total spending.

The output must include:

- Customer
- Total spending
- Rank

Customers with equal spending should receive the same rank.

---

### Challenge 3 — Previous Order

For every customer's order, display:

- Current order date
- Current order amount
- Previous order date
- Previous order amount

---

### Challenge 4 — Running Revenue

Calculate cumulative revenue by month.

Example:

January → ₹100,000  
February → ₹180,000  
March → ₹260,000

---

### Challenge 5 — CTE

Using a CTE, identify customers whose total spending is greater than the **average spending of all customers who have placed an order**.

---

# PART E — POSTGRESQL FEATURES

## JSONB

Products contain an `attributes` JSONB column.

Write queries to:

1. Find products of a particular brand.
2. Find products with a `warranty_months` attribute.
3. Find products with a warranty of at least 12 months.
4. Update one property inside the JSON document without replacing the entire document.

---

## UPSERT

Write a query that inserts inventory for a product.

If inventory already exists, update the existing quantity instead.

Use PostgreSQL's:

`INSERT ... ON CONFLICT`

---

## RETURNING

Demonstrate inserting a customer and immediately retrieving the generated customer ID without executing another SELECT query.

---

# PART F — VIEWS

Create a view called:

`customer_order_summary`

It should return:

- Customer ID
- Customer name
- Total orders
- Total spending
- Average order value
- Last order date

Then write a query using the view to find the **10 highest-value customers**.

### Deliverable

`04_views.sql`

---

# PART G — INDEXING

Assume the database has grown to:

- 1 million customers
- 5 million orders
- 20 million order items
- 100,000 products

Design indexes for frequently executed operations.

Examples include:

Finding orders belonging to a customer.

Finding orders between two dates.

Looking up a product by SKU.

Finding products belonging to a category.

Finding successful payments belonging to an order.

Searching JSONB product attributes.

For each index, explain:

1. What query it improves.
2. Why you selected those columns.
3. Whether the index has disadvantages.

You must include at least:

- Single-column index
- Composite index
- Unique index
- Partial index
- Appropriate JSONB index

### Deliverable

`05_indexes.sql`

---

# PART H — QUERY PERFORMANCE

Choose **three queries** from your assignment.

Run:

`EXPLAIN`

and:

`EXPLAIN ANALYZE`

Analyze the output.

Identify things such as:

- Sequential scans
- Index scans
- Estimated rows
- Actual rows
- Execution time

Where appropriate, create an index and compare the query plan **before and after**.

Document what changed.

### Deliverable

`06_performance.md`

---

# PART I — TRANSACTIONS

Implement the following scenario using a PostgreSQL transaction.

A customer purchases:

**2 units of Product A**

Your transaction must:

1. Check inventory.
2. Prevent concurrent purchases from overselling the product.
3. Create the order.
4. Create the order item.
5. Reduce inventory.
6. Record the payment.
7. Commit everything if successful.
8. Roll back everything if any operation fails.

Consider what could happen if only **one unit remains** while two customers attempt to purchase it simultaneously.

Your solution should demonstrate appropriate transaction and locking behaviour.

### Deliverable

`07_transactions.sql`

---

# PART J — DATA MODIFICATION CHALLENGES

Write SQL for the following.

### Challenge 1

Increase prices by **10%** for products belonging to a specified category.

---

### Challenge 2

Set products to `INACTIVE` when they have never been ordered and were created more than one year ago.

---

### Challenge 3

Delete addresses belonging to customers whose accounts have been deleted, if your schema permits such records to exist.

If your schema intentionally prevents this situation, explain why this cleanup query is unnecessary.

---

### Challenge 4

Cancel an order and restore its ordered quantities back into inventory.

This operation should be designed safely.

---

# PART K — DATABASE THEORY

Answer briefly in your README.

1. What is normalization?
2. Explain 1NF, 2NF and 3NF.
3. Why did you normalize your schema the way you did?
4. When might denormalization be useful?
5. What is ACID?
6. What is MVCC?
7. What is a database transaction?
8. What problems can concurrent transactions create?
9. What is a deadlock?
10. What is an index?
11. Why shouldn't every column be indexed?
12. What is the difference between a B-tree and GIN index?
13. What is the difference between `WHERE` and `HAVING`?
14. `INNER JOIN` vs `LEFT JOIN`?
15. `DELETE` vs `TRUNCATE` vs `DROP`?
16. `JSON` vs `JSONB` in PostgreSQL?
17. Primary key vs unique constraint?
18. `VARCHAR` vs `TEXT` in PostgreSQL?
19. What does `EXPLAIN ANALYZE` do?
20. Why are parameterized queries important?

---

# REQUIRED PROJECT STRUCTURE

Submit your project in the following structure:

```text
postgres-commerce-assignment/

├── README.md
├── 01_schema.sql
├── 02_seed_data.sql
├── 03_queries.sql
├── 04_views.sql
├── 05_indexes.sql
├── 06_performance.md
└── 07_transactions.sql
```

---

# RULES

You may use:

- PostgreSQL documentation
- General SQL documentation
- pgAdmin
- psql

You may research syntax when necessary.

Do not use an ORM.

All database operations must be implemented using **SQL/PostgreSQL directly**.

The database must be reproducible by executing your SQL files on a clean PostgreSQL database.

---

# EVALUATION

Your submission will be evaluated approximately as follows:

| Area | Weight |
|---|---:|
| Schema & database design | 20% |
| SQL queries | 25% |
| Advanced SQL | 15% |
| Transactions & concurrency | 15% |
| Indexes & performance | 15% |
| PostgreSQL-specific features | 5% |
| Code quality & explanation | 5% |

**Total: 100%**

---

# What We Are Looking For

We are not evaluating how much PostgreSQL syntax you have memorized.

We want to see whether you can:

**Requirement → Database Design → SQL → Correct Result → Performance → Data Integrity**

A strong submission should demonstrate that you can work with PostgreSQL confidently as a Full-Stack Developer on a production application.