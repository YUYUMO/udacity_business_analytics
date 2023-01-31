/* Query 1 - query used for first insight */
SELECT
    a.Name AS artist,
    COUNT(t.Name) AS tracks_number
FROM
    Artist a
    JOIN Album al ON a.ArtistId = al.ArtistId
    JOIN Track t ON al.AlbumId = t.AlbumId
    JOIN Genre g ON t.GenreId = g.GenreId
WHERE
    g.Name = "Rock"
GROUP BY
    1
ORDER BY
    tracks_number DESC
LIMIT
    10;

/* Query 2 - query used for second insight */
SELECT
    a.Name AS artist,
    SUM((il.UnitPrice) *(il.Quantity)) AS total_spend
FROM
    InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Artist a ON al.ArtistId = a.ArtistId
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT
    10;

/* Query 3 - query used for third insight */
SELECT
    m.Name AS media_type,
    SUM((il.UnitPrice) *(il.Quantity)) AS total_spend
FROM
    InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN MediaType m ON t.MediaTypeId = m.MediaTypeId
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT
    3;

/* Query 4 - query used for fourth insight */
WITH t1 AS (
    SELECT
        i.BillingCountry AS country,
        al.Title AS album_title,
        COUNT(i.InvoiceId) AS purchases
    FROM
        Invoice i
        JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
        JOIN Track t ON il.TrackId = t.TrackId
        JOIN Album al ON t.AlbumId = al.AlbumId
    GROUP BY
        1,
        2
    ORDER BY
        1,
        3 DESC
),
t2 AS (
    SELECT
        MAX(purchases) AS max_purchase,
        country,
        album_title
    FROM
        t1
    GROUP BY
        country
)
SELECT
    t1.*
FROM
    t1
    JOIN t2 ON t1.country = t2.Country
    AND t1.album_title = t2.album_title
WHERE
    t1.purchases = t2.max_purchase
    AND t2.max_purchase >= 5
ORDER BY
    3 DESC;