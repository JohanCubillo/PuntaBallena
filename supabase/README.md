# Supabase

Ejecuta `schema.sql` en el SQL Editor del proyecto Supabase. Antes de usar datos reales, revisa y prueba todas las políticas de RLS y Storage. La página pública solo debe tener la publishable/anon key, nunca la service_role key.

La carga de comprobantes debe implementarse con una función segura y un bucket privado. No crees políticas que permitan a cualquier visitante leer todos los archivos o reservas.
