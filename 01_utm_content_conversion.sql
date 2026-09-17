/* ============================================================
   FILE    : 01_utm_content_conversion.sql
   PROJECT : Maven Fuzzy Factory — Funnel Analysis
   PURPOSE : Session → Order conversion by UTM content
   AUTHOR  : Sumeyra Bayrak
   DATE    : 2026-09-17
   ============================================================ */

USE mavenfuzzyfactory;
-- 1) Schema check
SELECT * FROM website_sessions;
SELECT * FROM orders;

-- 2) Baseline: sessions by channel
SELECT 
	utm_content,
    COUNT(DISTINCT website_session_id) as sessions
FROM website_sessions
WHERE website_session_id BETWEEN 1000 AND 2000
GROUP BY utm_content
ORDER BY sessions DESC;

-- 3) Primary: sessions + orders + conversion rate
--    LEFT JOIN → non-converting channels kept at 0
--    DISTINCT   → prevents fan-out from join

SELECT
	website_sessions.utm_content,
	COUNT(DISTINCT website_sessions.website_session_id) sessions,
    COUNT(DISTINCT orders.order_id) as orders,
	COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) as sessions_to_orders_conv_rt
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.website_session_id BETWEEN 1000 AND 2000
GROUP BY website_sessions.utm_content
ORDER BY sessions DESC;


