-- Hotel Punta Ballena: esquema inicial de Supabase.
-- Ejecuta en Supabase > SQL Editor después de revisar las políticas.
-- No uses service_role key en el navegador.

create extension if not exists pgcrypto;

create table if not exists public.booking_requests (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  full_name text not null check (char_length(full_name) between 2 and 120),
  email text not null check (char_length(email) <= 254),
  phone text not null check (char_length(phone) between 6 and 40),
  service text not null check (service in ('Tours','Hospedaje','Restaurante','Eventos y experiencias especiales')),
  preferred_date date,
  guests integer not null default 1 check (guests between 1 and 100),
  notes text not null default '' check (char_length(notes) <= 2000),
  status text not null default 'new' check (status in ('new','contacted','awaiting_payment','payment_review','confirmed','rejected','cancelled')),
  admin_notes text not null default '',
  payment_amount numeric(12,2),
  payment_reference text,
  payment_status text not null default 'not_paid' check (payment_status in ('not_paid','proof_uploaded','verified','rejected')),
  receipt_storage_path text
);

alter table public.booking_requests enable row level security;

-- Público: solo puede crear solicitudes. No puede leer, editar ni borrar datos.
drop policy if exists "Public can submit booking requests" on public.booking_requests;
create policy "Public can submit booking requests"
on public.booking_requests for insert
to anon, authenticated
with check (
  status = 'new'
  and payment_status = 'not_paid'
  and admin_notes = ''
  and receipt_storage_path is null
  and payment_reference is null
);

-- Lectura/edición/borrado de reservas: solo usuarios autenticados que sean administradores.
-- La función comprueba una tabla allowlist privada.
create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.admin_users enable row level security;
revoke all on public.admin_users from anon, authenticated;
grant select on public.admin_users to authenticated;

create or replace function public.is_hotel_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.admin_users a
    where a.user_id = (select auth.uid())
  );
$$;

revoke all on function public.is_hotel_admin() from public;
grant execute on function public.is_hotel_admin() to authenticated;

drop policy if exists "Admins can read booking requests" on public.booking_requests;
create policy "Admins can read booking requests"
on public.booking_requests for select
to authenticated
using (public.is_hotel_admin());

drop policy if exists "Admins can update booking requests" on public.booking_requests;
create policy "Admins can update booking requests"
on public.booking_requests for update
to authenticated
using (public.is_hotel_admin())
with check (public.is_hotel_admin());

drop policy if exists "Admins can delete booking requests" on public.booking_requests;
create policy "Admins can delete booking requests"
on public.booking_requests for delete
to authenticated
using (public.is_hotel_admin());

-- Recomendación: en Supabase Storage crea un bucket PRIVADO llamado "payment-receipts".
-- No habilites acceso público. Sube comprobantes mediante una función/endpoint seguro
-- o políticas de Storage que validen al dueño de la reserva. No uses nombres de archivo
-- adivinables ni compartas URLs públicas.
