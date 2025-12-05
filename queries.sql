-- 1. Все задания определённого пользователя (user_id = 1)
SELECT t.id, t.title, t.description, s.name AS status, u.fullname
FROM tasks t
JOIN users u ON t.user_id = u.id
JOIN status s ON t.status_id = s.id
WHERE t.user_id = 1;

-- 2. Задания со статусом 'new'
SELECT *
FROM tasks
WHERE status_id = (SELECT id FROM status WHERE name = 'new');

-- 3. Обновить статус задачи (id = 1) на 'in progress'
UPDATE tasks
SET status_id = (SELECT id FROM status WHERE name = 'in progress')
WHERE id = 1;

-- 4. Пользователи без задач
SELECT u.*
FROM users u
LEFT JOIN tasks t ON u.id = t.user_id
WHERE t.id IS NULL;

-- 5. Добавить новое задание пользователю с id = 1
INSERT INTO tasks (title, description, status_id, user_id)
VALUES (
    'Homework task',
    'Do SQL homework',
    (SELECT id FROM status WHERE name = 'new'),
    1
);

-- 6. Все незавершённые задачи
SELECT *
FROM tasks
WHERE status_id != (SELECT id FROM status WHERE name = 'completed');

-- 7. Удалить задачу по id (пример: id = 2)
DELETE FROM tasks
WHERE id = 2;

-- 8. Найти пользователей по e-mail (например, gmail)
SELECT *
FROM users
WHERE email LIKE '%@gmail.com';

-- 9. Обновить имя пользователя (id = 1)
UPDATE users
SET fullname = 'Updated User Name'
WHERE id = 1;

-- 10. Количество задач по каждому статусу
SELECT s.name AS status_name,
       COUNT(t.id) AS task_count
FROM status s
LEFT JOIN tasks t ON t.status_id = s.id
GROUP BY s.id, s.name;

-- 11. Задачи пользователей с e-mail доменом '@example.com'
SELECT t.id, t.title, t.description, u.email
FROM tasks t
JOIN users u ON t.user_id = u.id
WHERE u.email LIKE '%@example.com';

-- 12. Задачи без описания
SELECT *
FROM tasks
WHERE description IS NULL OR description = '';

-- 13. Пользователи и их задачи в статусе 'in progress'
SELECT u.fullname, u.email, t.id AS task_id, t.title, t.description
FROM users u
JOIN tasks t ON u.id = t.user_id
JOIN status s ON t.status_id = s.id
WHERE s.name = 'in progress';

-- 14. Пользователи и количество их задач (включая тех, у кого 0)
SELECT u.id, u.fullname, u.email, COUNT(t.id) AS task_count
FROM users u
LEFT JOIN tasks t ON u.id = t.user_id
GROUP BY u.id, u.fullname, u.email;
