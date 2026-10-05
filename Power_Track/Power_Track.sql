CREATE DATABASE PowerPulse;

USE PowerPulse;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    customer_type VARCHAR(30),
    registration_date DATE
);

INSERT INTO customers
(customer_id, customer_name, phone, email, customer_type, registration_date)
VALUES
(1, 'Riya Shah', '9876543210', 'riya@gmail.com', 'Residential', '2025-01-10'),
(2, 'Aarav Patel', '9876543211', 'aarav@gmail.com', 'Residential', '2025-01-15'),
(3, 'Neha Mehta', '9876543212', 'neha@gmail.com', 'Residential', '2025-02-05'),
(4, 'Raj Enterprises', '9876543213', 'raj@business.com', 'Commercial', '2025-02-20'),
(5, 'Kiran Joshi', '9876543214', 'kiran@gmail.com', 'Residential', '2025-03-01'),
(6, 'Shree Mart', '9876543215', 'shreemart@gmail.com', 'Commercial', '2025-03-10'),
(7, 'Vikram Desai', '9876543216', 'vikram@gmail.com', 'Residential', '2025-03-18'),
(8, 'Pooja Patel', '9876543217', 'pooja@gmail.com', 'Residential', '2025-04-02'),
(9, 'Green Cafe', '9876543218', 'greencafe@gmail.com', 'Commercial', '2025-04-15'),
(10, 'Amit Shah', '9876543219', 'amit@gmail.com', 'Residential', '2025-05-01');

CREATE TABLE properties (
    property_id INT PRIMARY KEY,
    customer_id INT,
    address VARCHAR(200),
    city VARCHAR(50),
    zone VARCHAR(50),
    property_type VARCHAR(30),
    sanctioned_load_kw DECIMAL(10,2),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);
INSERT INTO properties
(property_id, customer_id, address, city, zone, property_type, sanctioned_load_kw)
VALUES
(101, 1, 'Adajan', 'Surat', 'West Zone', 'House', 5.00),
(102, 2, 'Vesu', 'Surat', 'West Zone', 'House', 6.00),
(103, 3, 'Katargam', 'Surat', 'North Zone', 'House', 4.00),
(104, 4, 'Ring Road', 'Surat', 'Central Zone', 'Office', 25.00),
(105, 5, 'Varachha', 'Surat', 'East Zone', 'House', 5.00),
(106, 6, 'Udhna', 'Surat', 'South Zone', 'Shop', 15.00),
(107, 7, 'City Light', 'Surat', 'West Zone', 'House', 7.00),
(108, 8, 'Palanpur', 'Surat', 'North Zone', 'House', 5.00),
(109, 9, 'Athwa', 'Surat', 'Central Zone', 'Shop', 12.00),
(110, 10, 'Piplod', 'Surat', 'West Zone', 'House', 6.00);

CREATE TABLE meters (
    meter_id INT PRIMARY KEY,
    property_id INT,
    meter_number VARCHAR(50) UNIQUE,
    meter_type VARCHAR(30),
    installation_date DATE,
    meter_status VARCHAR(20),

    FOREIGN KEY (property_id)
    REFERENCES properties(property_id)
);

INSERT INTO meters
(meter_id, property_id, meter_number, meter_type, installation_date, meter_status)
VALUES
(201, 101, 'MTR1001', 'Smart', '2025-01-15', 'Active'),
(202, 102, 'MTR1002', 'Smart', '2025-01-20', 'Active'),
(203, 103, 'MTR1003', 'Normal', '2025-02-10', 'Active'),
(204, 104, 'MTR1004', 'Smart', '2025-02-25', 'Active'),
(205, 105, 'MTR1005', 'Normal', '2025-03-05', 'Active'),
(206, 106, 'MTR1006', 'Smart', '2025-03-15', 'Active'),
(207, 107, 'MTR1007', 'Smart', '2025-03-25', 'Active'),
(208, 108, 'MTR1008', 'Normal', '2025-04-05', 'Active'),
(209, 109, 'MTR1009', 'Smart', '2025-04-20', 'Active'),
(210, 110, 'MTR1010', 'Smart', '2025-05-05', 'Active');

CREATE TABLE meter_readings (
    reading_id INT PRIMARY KEY,
    meter_id INT,
    reading_date DATE,
    previous_reading DECIMAL(10,2),
    current_reading DECIMAL(10,2),
    units_consumed DECIMAL(10,2),
    peak_units DECIMAL(10,2),
    off_peak_units DECIMAL(10,2),

    FOREIGN KEY (meter_id)
    REFERENCES meters(meter_id)
);

INSERT INTO meter_readings
(reading_id, meter_id, reading_date, previous_reading, current_reading, units_consumed, peak_units, off_peak_units)
VALUES
(301, 201, '2025-06-01', 1200, 1350, 150, 90, 60),
(302, 202, '2025-06-01', 2100, 2300, 200, 120, 80),
(303, 203, '2025-06-01', 900, 1020, 120, 70, 50),
(304, 204, '2025-06-01', 5000, 5700, 700, 450, 250),
(305, 205, '2025-06-01', 1500, 1650, 150, 85, 65),
(306, 206, '2025-06-01', 3000, 3400, 400, 250, 150),
(307, 207, '2025-06-01', 1800, 2000, 200, 120, 80),
(308, 208, '2025-06-01', 1100, 1230, 130, 75, 55),
(309, 209, '2025-06-01', 2500, 2850, 350, 210, 140),
(310, 210, '2025-06-01', 1400, 1550, 150, 90, 60);

CREATE TABLE electricity_bills (
    bill_id INT PRIMARY KEY,
    meter_id INT,
    billing_date DATE,
    billing_month VARCHAR(20),
    units_consumed DECIMAL(10,2),
    rate_per_unit DECIMAL(10,2),
    fixed_charge DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    due_date DATE,

    FOREIGN KEY (meter_id)
    REFERENCES meters(meter_id)
);

INSERT INTO electricity_bills
(bill_id, meter_id, billing_date, billing_month, units_consumed, rate_per_unit, fixed_charge, tax_amount, total_amount, payment_status, due_date)
VALUES
(401, 201, '2025-06-01', 'June', 150, 6.50, 100, 50, 1125, 'Paid', '2025-06-15'),
(402, 202, '2025-06-01', 'June', 200, 6.50, 100, 65, 1465, 'Paid', '2025-06-15'),
(403, 203, '2025-06-01', 'June', 120, 6.00, 80, 40, 840, 'Paid', '2025-06-15'),
(404, 204, '2025-06-01', 'June', 700, 8.00, 300, 150, 6050, 'Pending', '2025-06-15'),
(405, 205, '2025-06-01', 'June', 150, 6.50, 100, 50, 1125, 'Paid', '2025-06-15'),
(406, 206, '2025-06-01', 'June', 400, 7.00, 200, 100, 3100, 'Pending', '2025-06-15'),
(407, 207, '2025-06-01', 'June', 200, 6.50, 100, 65, 1465, 'Paid', '2025-06-15'),
(408, 208, '2025-06-01', 'June', 130, 6.00, 80, 40, 900, 'Paid', '2025-06-15'),
(409, 209, '2025-06-01', 'June', 350, 7.00, 200, 90, 2740, 'Pending', '2025-06-15'),
(410, 210, '2025-06-01', 'June', 150, 6.50, 100, 50, 1125, 'Paid', '2025-06-15');

CREATE TABLE complaints (
    complaint_id INT PRIMARY KEY,
    customer_id INT,
    meter_id INT,
    complaint_type VARCHAR(50),
    complaint_date DATE,
    priority VARCHAR(20),
    status VARCHAR(20),
    resolution_date DATE,
    resolution_hours DECIMAL(10,2),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    FOREIGN KEY (meter_id)
    REFERENCES meters(meter_id)
);
INSERT INTO complaints
(complaint_id, customer_id, meter_id, complaint_type, complaint_date, priority, status, resolution_date, resolution_hours)
VALUES
(501, 1, 201, 'Power Cut', '2025-06-03', 'High', 'Resolved', '2025-06-03', 4),
(502, 2, 202, 'Voltage Issue', '2025-06-05', 'Medium', 'Resolved', '2025-06-06', 20),
(503, 3, 203, 'Meter Issue', '2025-06-07', 'Low', 'Resolved', '2025-06-08', 24),
(504, 4, 204, 'Power Cut', '2025-06-10', 'High', 'Open', NULL, NULL),
(505, 5, 205, 'Voltage Issue', '2025-06-11', 'Medium', 'Resolved', '2025-06-11', 8),
(506, 6, 206, 'Meter Issue', '2025-06-12', 'High', 'Resolved', '2025-06-13', 18),
(507, 7, 207, 'Power Cut', '2025-06-14', 'High', 'Resolved', '2025-06-14', 5),
(508, 8, 208, 'Billing Issue', '2025-06-15', 'Low', 'Open', NULL, NULL),
(509, 9, 209, 'Power Cut', '2025-06-16', 'High', 'Resolved', '2025-06-17', 12),
(510, 10, 210, 'Voltage Issue', '2025-06-18', 'Medium', 'Resolved', '2025-06-18', 6);

SELECT * FROM customers;
SELECT * FROM properties;
SELECT * FROM meters;
SELECT * FROM meter_readings;
SELECT * FROM electricity_bills;
SELECT * FROM complaints;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_properties
FROM properties;

SELECT COUNT(*) AS active_meters
FROM meters
WHERE meter_status = 'Active';

SELECT SUM(units_consumed) AS total_units
FROM meter_readings;

SELECT AVG(units_consumed) AS average_consumption
FROM meter_readings;

SELECT MAX(units_consumed) AS highest_consumption
FROM meter_readings;

SELECT MIN(units_consumed) AS lowest_consumption
FROM meter_readings;

SELECT SUM(total_amount) AS total_bill_amount
FROM electricity_bills;

SELECT MAX(total_amount) AS highest_bill
FROM electricity_bills;
SELECT COUNT(*) AS pending_bills
FROM electricity_bills
WHERE payment_status = 'Pending';

-- Zone wise Consumption
SELECT 
    p.zone,
    SUM(mr.units_consumed) AS total_units
FROM properties p
JOIN meters m 
    ON p.property_id = m.property_id
JOIN meter_readings mr 
    ON m.meter_id = mr.meter_id
GROUP BY p.zone;

-- Customer-wise electricity consumption
SELECT 
    c.customer_name,
    mr.units_consumed
FROM customers c
JOIN properties p 
    ON c.customer_id = p.customer_id
JOIN meters m 
    ON p.property_id = m.property_id
JOIN meter_readings mr 
    ON m.meter_id = mr.meter_id
ORDER BY mr.units_consumed DESC;

-- Residential vs Commercial consumption
SELECT 
    c.customer_type,
    SUM(mr.units_consumed) AS total_units
FROM customers c
JOIN properties p 
    ON c.customer_id = p.customer_id
JOIN meters m 
    ON p.property_id = m.property_id
JOIN meter_readings mr 
    ON m.meter_id = mr.meter_id
GROUP BY c.customer_type;

-- Count customers by type
SELECT 
    customer_type,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_type;

-- Average consumption by property type
SELECT 
    p.property_type,
    AVG(mr.units_consumed) AS average_units
FROM properties p
JOIN meters m 
    ON p.property_id = m.property_id
JOIN meter_readings mr 
    ON m.meter_id = mr.meter_id
GROUP BY p.property_type;

-- Display customer name, meter number and consumption
SELECT 
    c.customer_name,
    m.meter_number,
    mr.units_consumed
FROM customers c
JOIN properties p 
    ON c.customer_id = p.customer_id
JOIN meters m 
    ON p.property_id = m.property_id
JOIN meter_readings mr 
    ON m.meter_id = mr.meter_id;

--  Find customers with bills greater than ₹2,000
SELECT 
    c.customer_name,
    eb.total_amount
FROM customers c
JOIN properties p 
    ON c.customer_id = p.customer_id
JOIN meters m 
    ON p.property_id = m.property_id
JOIN electricity_bills eb 
    ON m.meter_id = eb.meter_id
WHERE eb.total_amount > 2000;

-- find customers who have pending bills
SELECT 
    c.customer_name,
    eb.total_amount,
    eb.payment_status
FROM customers c
JOIN properties p 
    ON c.customer_id = p.customer_id
JOIN meters m 
    ON p.property_id = m.property_id
JOIN electricity_bills eb 
    ON m.meter_id = eb.meter_id
WHERE eb.payment_status = 'Pending';

-- Find customers who raised complaints
SELECT DISTINCT
    c.customer_name
FROM customers c
JOIN complaints co
    ON c.customer_id = co.customer_id;
    
    -- Display complaint details with customer names
SELECT 
    c.customer_name,
    co.complaint_type,
    co.priority,
    co.status,
    co.resolution_hours
FROM customers c
JOIN complaints co
    ON c.customer_id = co.customer_id;
    
   -- Find the zone with the highest electricity consumption
SELECT 
    p.zone,
    SUM(mr.units_consumed) AS total_units
FROM properties p
JOIN meters m
    ON p.property_id = m.property_id
JOIN meter_readings mr
    ON m.meter_id = mr.meter_id
GROUP BY p.zone
ORDER BY total_units DESC
LIMIT 1;


-- Find customers whose consumption is above average
SELECT 
    c.customer_name,
    mr.units_consumed
FROM customers c
JOIN properties p 
    ON c.customer_id = p.customer_id
JOIN meters m 
    ON p.property_id = m.property_id
JOIN meter_readings mr 
    ON m.meter_id = mr.meter_id
WHERE mr.units_consumed >
(
    SELECT AVG(units_consumed)
    FROM meter_readings
);


-- Find the highest bill in each customer type
SELECT 
    c.customer_type,
    MAX(eb.total_amount) AS highest_bill
FROM customers c
JOIN properties p
    ON c.customer_id = p.customer_id
JOIN meters m
    ON p.property_id = m.property_id
JOIN electricity_bills eb
    ON m.meter_id = eb.meter_id
GROUP BY c.customer_type;



-- Calculate peak vs off-peak consumption
SELECT
    SUM(peak_units) AS total_peak_units,
    SUM(off_peak_units) AS total_off_peak_units
FROM meter_readings;


-- Find customers using more than 300 units
SELECT 
    c.customer_name,
    mr.units_consumed
FROM customers c
JOIN properties p
    ON c.customer_id = p.customer_id
JOIN meters m
    ON p.property_id = m.property_id
JOIN meter_readings mr
    ON m.meter_id = mr.meter_id
WHERE mr.units_consumed > 300
ORDER BY mr.units_consumed DESC;




-- Identify customers who have BOTH high consumption (>300 units) AND pending bills.
SELECT 
    c.customer_name,
    mr.units_consumed,
    eb.total_amount,
    eb.payment_status
FROM customers c
JOIN properties p
    ON c.customer_id = p.customer_id
JOIN meters m
    ON p.property_id = m.property_id
JOIN meter_readings mr
    ON m.meter_id = mr.meter_id
JOIN electricity_bills eb
    ON m.meter_id = eb.meter_id
WHERE mr.units_consumed > 300
AND eb.payment_status = 'Pending';