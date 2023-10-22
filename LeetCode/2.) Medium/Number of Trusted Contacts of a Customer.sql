/* Write an SQL query to find the following for each invoice_id:

   customer_name: The name of the customer the invoice is related to.
   price: The price of the invoice.
   contacts_cnt: The number of contacts related to the customer.
   trusted_contacts_cnt: The number of contacts related to the customer and at the same time they are customers to the shop. (i.e their email exists in the Customers table.)
   Return the result table ordered by invoice_id. */

WITH NewContacts AS
(
    SELECT
        C1.user_id,
        C2.customer_id AS contact_id,
        C1.contact_name,
        C1.contact_email
    FROM Contacts C1
    LEFT JOIN Customers C2 ON C1.contact_name = C2.customer_name
)
SELECT
    I.invoice_id,
    C.customer_name,
    I.price,
    COUNT(N.contact_name) AS contacts_cnt,
    COUNT(N.contact_id) AS trusted_contacts_cnt
FROM Invoices I
LEFT JOIN Customers C ON I.user_id = C.customer_id
LEFT JOIN NewContacts N ON C.customer_id = N.user_id
GROUP BY I.invoice_id
ORDER BY I.invoice_id;
