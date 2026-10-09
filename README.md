# Hotel Punta Ballena — proyecto inicial

Sitio inicial para un alojamiento de naturaleza en Costa Rica: tours, hospedaje, restaurante y eventos/experiencias especiales.

## Incluye

- `index.html`: sitio público adaptable a celular y computadora.
- `styles.css`: estilos visuales.
- `app.js`: menú, formulario y conexión opcional de solicitudes con Supabase.
- `admin.html`: maqueta del panel de administración (no operativo todavía).
- `config.js`: configuración pública de Supabase y datos que se pueden publicar.
- `supabase/schema.sql`: esquema inicial y políticas de seguridad para solicitudes.

## Estado actual: prototipo

La web pública puede abrirse localmente. El formulario no guardará datos hasta que se configure Supabase. La pantalla de administración es solo una maqueta; no debe considerarse segura ni usarse para operar hasta implementar Supabase Auth, cargar un usuario administrador, políticas de Storage y las funciones administrativas.

Las fotos usan URLs de Unsplash como imágenes de muestra. Sustitúyelas por fotos autorizadas del establecimiento cuando las tengas.

## Probar en Windows

1. Extrae el ZIP en una carpeta, por ejemplo `C:\Users\TU_USUARIO\Desktop\hotel-punta-ballena`.
2. Abre `index.html` en el navegador para ver el diseño.
3. Para evitar limitaciones del navegador y probar scripts, puedes abrir la carpeta con VS Code y usar la extensión Live Server.
4. No pongas información real de clientes en esta versión sin conexión segura.

## Conectar Supabase (base de datos)

1. Crea un proyecto en Supabase.
2. En el SQL Editor, revisa y ejecuta `supabase/schema.sql`.
3. En Project Settings / API copia la URL del proyecto y la publishable/anon key.
4. Pon esos dos valores en `config.js`:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
5. Nunca pegues `service_role` ni una clave secreta en archivos del sitio público.
6. Crea un usuario de administrador en Authentication.
7. Añade el UUID de ese usuario a `public.admin_users` desde el SQL Editor (con una cuenta propietaria/administradora del proyecto). No abras esa tabla al público.
8. Antes de operar, prueba que una visita anónima pueda insertar una solicitud, pero no pueda leer, cambiar ni borrar solicitudes ajenas.

## SINPE Móvil y comprobantes

El flujo previsto es:
1. El hotel revisa la solicitud y comunica disponibilidad, monto y número SINPE por un canal apropiado.
2. El cliente realiza la transferencia desde su banco.
3. El cliente sube el comprobante en un formulario asociado a la reserva.
4. El archivo queda en un bucket privado, no público.
5. El administrador revisa el comprobante y verifica el depósito en su cuenta antes de marcarlo como pagado/confirmado.

Este ZIP aún **no** implementa la carga de comprobantes ni la confirmación administrativa. Para hacerlo correctamente, hace falta un endpoint/Edge Function que valide la reserva, el tipo/tamaño del archivo, evite abuso y aplique políticas de acceso. Un comprobante enviado no demuestra por sí solo que el dinero llegó.

## Google Drive

La integración con Drive no está activada en este prototipo. Para integrarla de forma segura, hay que crear un proyecto de Google Cloud, habilitar Google Drive API y configurar OAuth o una cuenta de servicio según el tipo de cuenta y el uso. Los secretos deben permanecer en una función del servidor, nunca en `config.js` ni en GitHub. Recomendación: Drive para fotos/documentos y almacenamiento privado de Supabase para comprobantes sensibles.

## Publicación futura en GitHub Pages

La publicación y el cambio de dominio se harán al final, como acordamos. Recuerda: GitHub Pages solo sirve archivos estáticos; la base de datos, la autenticación y la subida privada de comprobantes dependen de servicios backend externos.

## Próximos pasos recomendados

1. Confirmar nombre, textos, ubicación exacta, teléfono y fotografías.
2. Conectar Supabase y probar las solicitudes.
3. Implementar inicio de sesión y panel real.
4. Añadir flujo de SINPE y comprobantes privados.
5. Conectar Google Drive con credenciales protegidas.
6. Probar permisos y seguridad.
7. Publicar en GitHub Pages y configurar el dominio al final.
"# PuntaBallena" 
