create materialized view users_view as
  with t as (
    select *, row_number() over(partition by uuid order by inserted_at desc) as row_number
    from events
    where type = 'user_updated'
  )
select uuid, body->>'name' as name, inserted_at from t where row_number = 1
with no data;
