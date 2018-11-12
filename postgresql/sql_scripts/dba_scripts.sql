-- To show max connection
SHOW max_connections;

-- To display actives connections
SELECT COUNT(client_addr) FROM  pg_stat_activity;

-- To display the activity of your database
SELECT * FROM  pg_stat_activity WHERE datname = 'your_database_name' ORDER BY backend_start;

-- To display connections by client_addr
SELECT client_addr, COUNT(client_addr) AS connecciones FROM pg_stat_activity GROUP BY client_addr ORDER BY client_addr ASC;

