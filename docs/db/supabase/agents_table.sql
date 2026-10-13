create table if not exists public.agents (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.users(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 100),
  token_hash text not null unique,
  version text,
  created_at timestamptz not null default now(),
  last_seen_at timestamptz,
  revoked_at timestamptz
);

create index if not exists agents_owner_id_idx on public.agents(owner_id);
create index if not exists agents_token_hash_idx on public.agents(token_hash);

-- The dashboard server uses the service key and enforces tenant access in its routes.
alter table public.agents disable row level security;
