/* Write an SQL query to find the average time each machine takes to complete a process.

   The time to complete a process is the 'end' timestamp minus the 'start' timestamp. 
   The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

   The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places. */
 
WITH NumberOfProcesses AS
(
    SELECT
        machine_id,
        COUNT(DISTINCT process_id) AS num_processes
    FROM Activity
    GROUP BY machine_id
    ORDER BY machine_id
)
SELECT
    machine_id,
    ROUND((SUM(CASE WHEN activity_type = 'end' THEN timestamp ELSE 0 END)-
           SUM(CASE WHEN activity_type = 'start' THEN timestamp ELSE 0 END))/
          (SELECT num_processes
           FROM NumberOfProcesses N
           WHERE N.machine_id = A.machine_id), 3) AS processing_time
FROM Activity A
GROUP BY machine_id
ORDER BY machine_id;
