# Lab Task 9 — Advanced SQL Techniques

**Duration:** 30–40 min | **Difficulty:** ⭐⭐⭐⭐ (Medium-Hard)

## Queries to Write

1. **View:** Create `v_order_summary` showing order_id, customer name, total items, total amount
2. **Stored Procedure:** Create `sp_place_order(customer_id, product_id, quantity)` that inserts an order + order item
3. **Function:** Create `fn_get_category_revenue(category_id)` returns total revenue
4. **Trigger:** Create trigger that logs product price changes to `audit_log`
5. **Transaction:** Place an order with stock reduction atomically

## Grading

| Criteria | Points |
|----------|:------:|
| View | 20 |
| Stored Procedure | 25 |
| Function | 20 |
| Trigger | 20 |
| Transaction | 15 |
| **Total** | **100** |
