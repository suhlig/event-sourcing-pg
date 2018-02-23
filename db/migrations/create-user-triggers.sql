create or replace function fn_project_user_create(uuid uuid, body jsonb) returns integer as $$
  declare result int;
  begin
    insert into users(uuid, name, inserted_at, updated_at)
    values(uuid, body->>'name', NOW(), NOW())
    returning id into result;
   return result;
  end;
$$ language plpgsql security definer;

create or replace function fn_project_user_update(uuid uuid, body jsonb) returns void as $$
  begin
    update users SET name = body->>'name', updated_at = NOW()
      where users.uuid = fn_project_user_update.uuid;
  end;
$$ language plpgsql security definer;

create or replace function fn_trigger_user_create() returns trigger
  security definer
  language plpgsql
as $$
  begin
    perform fn_project_user_create(new.uuid, new.body);
    return new;
  end;
$$;

create or replace function fn_trigger_user_update() returns trigger
  security definer
  language plpgsql
as $$
  begin
    perform fn_project_user_update(new.uuid, new.body);
    return new;
  end;
$$;

create trigger event_insert_user_create after insert on events
  for each row
  when (new.type = 'user_create')
  execute procedure fn_trigger_user_create();

create trigger event_insert_user_update after insert on events
  for each row
  when (new.type = 'user_update')
  execute procedure fn_trigger_user_update();
