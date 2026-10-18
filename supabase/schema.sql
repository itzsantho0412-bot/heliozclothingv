-- Run this in Supabase SQL Editor.
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price numeric(10,2) not null default 0 check (price >= 0),
  description text not null default '',
  category text not null default 'T-shirts',
  sizes text[] not null default array['S','M','L','XL'],
  colors text[] not null default array['Black','White'],
  stock integer not null default 0 check (stock >= 0),
  image_url text not null default '',
  created_at timestamptz not null default now()
);
alter table public.products enable row level security;
drop policy if exists "Products are publicly readable" on public.products;
create policy "Products are publicly readable" on public.products for select using (true);
-- Admin writes require an authenticated Supabase user. For a production store,
-- add an admin allowlist table and policies restricting writes to approved user IDs.
drop policy if exists "Authenticated users can insert products" on public.products;
create policy "Authenticated users can insert products" on public.products for insert to authenticated with check (auth.uid() is not null);
drop policy if exists "Authenticated users can update products" on public.products;
create policy "Authenticated users can update products" on public.products for update to authenticated using (auth.uid() is not null) with check (auth.uid() is not null);
drop policy if exists "Authenticated users can delete products" on public.products;
create policy "Authenticated users can delete products" on public.products for delete to authenticated using (auth.uid() is not null);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images','product-images',true,10485760,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set file_size_limit=excluded.file_size_limit, allowed_mime_types=excluded.allowed_mime_types;

drop policy if exists "Product images are public" on storage.objects;
create policy "Product images are public" on storage.objects for select using (bucket_id = 'product-images');
drop policy if exists "Authenticated users upload product images" on storage.objects;
create policy "Authenticated users upload product images" on storage.objects for insert to authenticated with check (bucket_id = 'product-images' and auth.uid() is not null);
drop policy if exists "Authenticated users update product images" on storage.objects;
create policy "Authenticated users update product images" on storage.objects for update to authenticated using (bucket_id = 'product-images' and auth.uid() is not null) with check (bucket_id = 'product-images' and auth.uid() is not null);
drop policy if exists "Authenticated users delete product images" on storage.objects;
create policy "Authenticated users delete product images" on storage.objects for delete to authenticated using (bucket_id = 'product-images' and auth.uid() is not null);

-- SECURITY TODO BEFORE PUBLIC LAUNCH:
-- Replace the broad authenticated write policies with an admin allowlist policy.
-- A basic policy template is:
-- exists (select 1 from public.admin_users a where a.user_id = auth.uid())
-- Create public.admin_users (user_id uuid primary key references auth.users(id)).
-- Add only the owner's auth user ID to admin_users, then use that condition for
-- all product and storage INSERT/UPDATE/DELETE policies. Never expose service-role keys.
