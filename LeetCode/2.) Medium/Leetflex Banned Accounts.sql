/* Write an SQL query to find the account_id of the accounts that should be banned from Leetflex.
   An account should be banned if it was logged in at some moment from two different IP addresses. */

SELECT DISTINCT L1.account_id
FROM LogInfo L1
INNER JOIN LogInfo L2 ON L1.account_id = L2.account_id
WHERE L1.login BETWEEN L2.login AND L2.logout AND
      L1.ip_address != L2.ip_address;
