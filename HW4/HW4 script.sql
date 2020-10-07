use classicmodels;

-- task 1 --
select *
from orders o1
join orderdetails o2
on o1.orderNumber = o2.orderNumber
-- answer: --

-- task 2 --
select o2.orderNumber, o1.status, round(sum(o2.quantityOrdered * o2.priceEach)) totalsales
from orders o1
join orderdetails o2
on o1.orderNumber = o2.orderNumber
-- answer: total sales = 9 604 191

-- task 3 --
select o.orderDate, e.lastName, e.firstName
from customers c
join employees e
on c.salesRepEmployeeNumber = e.employeeNumber
join orders o
on c.customerNumber = o.customerNumber
-- answer:--

-- task 5 --
select od.orderNumber, od.priceEach, od.quantityOrdered, p.productName, p.productLine, c.city, c.country, o.orderDate
from products p
join orderdetails od
on p.productCode = od.productCode
join orders o
on o.orderNumber = od.orderNumber
join customers c
on c.customerNumber = o.customerNumber
-- answer: --