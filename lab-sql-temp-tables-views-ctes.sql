use sakila;




-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).


-- count rentalID group by customer_id use as link to customer table as rental count
-- create view summarizes_rental_information as
select customer.customer_id, concat(first_name, " ", last_name) as "name", email, count(rental_ID) as rental_count
from customer
left join rental
using (customer_id)
group by customer_id;
select * from summarizes_rental_information;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

create temporary table total_amount_paid_per_cus1 as 
select customer_id, name, email,
rental_count,
sum(amount) as total_paid
from  summarizes_rental_information
left join payment
using (customer_id)
group by customer_id;

select * from total_amount_paid_per_cus1;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

with customer_summary_report as( 
select 
summarizes_rental_information.name
, summarizes_rental_information.email
, summarizes_rental_information.rental_count
, total_amount_paid_per_cus1.total_paid
from summarizes_rental_information
left join total_amount_paid_per_cus1
using (customer_id))

select name
, email
, rental_count
, total_paid,
avg(total_paid),
total_paid/rental_count as average_payment_per_rental
from customer_summary_report
group by name
, email
, rental_count
, total_paid;






-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.