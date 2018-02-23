drop function if exists fn_project_user_create(uuid uuid, body jsonb);
drop function if exists fn_project_user_update(uuid uuid, body jsonb);
drop trigger if exists event_insert_user_create ON events;
drop trigger if exists event_insert_user_update ON events;
