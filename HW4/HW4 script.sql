use classicmodels;

select od.orderNumber, od.priceEach, od.quantityOrdered, p.productName, p.productLine, c.city, c.country, o.orderDate
from products p
join orderdetails od
on p.productCode = od.productCode
join orders o
on o.orderNumber = od.orderNumber
join customers c
on c.customerNumber = o.customerNumber