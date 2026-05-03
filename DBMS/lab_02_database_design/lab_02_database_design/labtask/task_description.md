# Lab Task 2 — Design an E-Commerce Database

**Duration:** 40–50 minutes  
**Difficulty:** ⭐⭐⭐ (Medium)

## Requirements

Design and implement the **ShopBD E-Commerce database**:

1. **Draw the ERD** using Mermaid syntax (in a `.md` file or comment)
2. **Create database** `ecommerce_db`
3. **Create 5 tables** in correct dependency order:
   - `categories` → `products` → `customers` → `orders` → `order_items`
4. **Insert sample data** (5 categories, 10 products, 5 customers, 5 orders, 15 order items)
5. **Verify** with `SELECT * FROM each_table;`

## Table Specifications

### categories
`category_id (PK, AI)`, `name (NOT NULL, UNIQUE)`, `description`, `created_at`

### products
`product_id (PK, AI)`, `name (NOT NULL)`, `description`, `price (NOT NULL, CHECK >= 0)`, `stock (DEFAULT 0)`, `is_active (DEFAULT TRUE)`, `category_id (FK)`, `created_at`

### customers
`customer_id (PK, AI)`, `first_name (NOT NULL)`, `last_name (NOT NULL)`, `email (NOT NULL, UNIQUE)`, `phone`, `address`, `city (DEFAULT 'Dhaka')`, `created_at`

### orders
`order_id (PK, AI)`, `customer_id (FK, NOT NULL)`, `order_date (NOT NULL)`, `status (ENUM)`, `total_amount`, `created_at`

### order_items
`order_item_id (PK, AI)`, `order_id (FK, NOT NULL)`, `product_id (FK, NOT NULL)`, `quantity (NOT NULL, CHECK > 0)`, `unit_price (NOT NULL)`

## Grading Criteria

| Criteria | Points |
|----------|:------:|
| Mermaid ERD | 15 |
| Correct table creation order | 10 |
| Correct data types | 15 |
| All constraints | 20 |
| Referential integrity actions | 10 |
| Realistic sample data | 15 |
| Naming & formatting | 5 |
| SELECT verification | 10 |
| **Total** | **100** |
