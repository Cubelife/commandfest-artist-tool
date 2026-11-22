-- Commandfest artist tool: one row per signed-in person, holding their collection.
create table if not exists public.collections (
  user_id    uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  col        jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Each person can only see and change their own row.
alter table public.collections enable row level security;

drop policy if exists "Read own collection"   on public.collections;
drop policy if exists "Create own collection" on public.collections;
drop policy if exists "Update own collection" on public.collections;
drop policy if exists "Delete own collection" on public.collections;

create policy "Read own collection"   on public.collections for select to authenticated using (auth.uid() = user_id);
create policy "Create own collection" on public.collections for insert to authenticated with check (auth.uid() = user_id);
create policy "Update own collection" on public.collections for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Delete own collection" on public.collections for delete to authenticated using (auth.uid() = user_id);
