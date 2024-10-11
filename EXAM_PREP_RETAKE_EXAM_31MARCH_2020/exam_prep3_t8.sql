SELECT
    p.id AS `photo_id`,
    (SELECT COUNT(l.id) FROM likes l WHERE l.photo_id = p.id) AS `likes_count`,
    (SELECT COUNT(c.id) FROM comments c WHERE c.photo_id = p.id) AS `comments_count`
FROM photos AS p
    LEFT JOIN users_photos AS up ON p.id = up.photo_id
    LEFT JOIN likes AS l ON up.photo_id = l.photo_id
    LEFT JOIN comments AS c ON up.photo_id = c.photo_id
GROUP BY p.id
ORDER BY likes_count DESC, comments_count DESC, p.id;