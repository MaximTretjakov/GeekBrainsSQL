/*
	“Операторы, фильтрация, сортировка и ограничение. Агрегация данных”.

	1. Пусть задан некоторый пользователь. 
	Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
*/


SELECT	COUNT(id) max_messages, 
		from_user_id,
		to_user_id, 
		body
FROM messages
WHERE from_user_id IN (
  SELECT initiator_user_id FROM friend_requests WHERE (target_user_id = 1) AND status='approved'
  union
  SELECT target_user_id FROM friend_requests WHERE (initiator_user_id = 1) AND status='approved'
  AND to_user_id = 1
)
GROUP BY from_user_id, to_user_id , body
;

/*
	2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
*/

SELECT 
	user_id ,
	COUNT(*)
FROM likes 
WHERE user_id IN (
  SELECT id FROM media WHERE TIMESTAMPDIFF(YEAR, created_at , NOW()) < 10
)
GROUP BY user_id 
;



/*
	3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/

Было час ночи и я засыпал )))
