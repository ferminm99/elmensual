# El Mensual — Project Master Guide

Guía principal de arquitectura, lineamientos y estado funcional actual del sistema.

---

## 1. Propósito del sistema

El Mensual es un sistema de gestión operativa para:

- Inventario de artículos (bombachas por talle/color)
- Registro y gestión de pedidos
- Gestión de clientes
- Gestión de ventas y facturación
- Calendario de compras/agenda operativa
- Gestión de localidades y disponibilidad

Está orientado a uso diario con alta frecuencia de operaciones CRUD y acciones masivas.

---

## 2. Stack y arquitectura

## Frontend

- Vue + Vuetify (Single Page App)
- Router con rutas protegidas (`meta.requiresAuth`)
- Drawer lateral de navegación (`app.vue`)
- Componentes principales por módulo
- Utilidades de cache sincronizada (`useSyncedCache`, `cacheEvents`, `cacheFreshness`)
- Export/import de datos en Excel en varios módulos

## Backend

- Laravel
- API REST bajo `/api/...`
- Middleware de autenticación por token (`token-auth`)
- Controladores por dominio (Artículos, Ventas, Clientes, Calendario, Localidades, etc.)
- Endpoints de sincronización incremental (última actualización / actualizados desde)

## Modelo de navegación

Rutas frontend protegidas:

- `/` → Inventario
- `/clientes`
- `/comprascalendario`
- `/managearticulos`
- `/managepedidos`
- `/localidades`
- `/ventas`
- `/login` (pública)

---

## 3. Menú principal actual (estado real)

En `frontend/src/app.vue`, el drawer muestra:

1. Inventario
2. Clientes
3. Calendario
4. Artículos
5. Pedidos
6. Localidades
7. Ventas
8. Cerrar sesión

Incluye:

- App bar con botón hamburguesa
- Modo responsive (`temporary` en mobile, `permanent` en desktop)
- Resaltado de ítem activo
- Snackbar global para feedback de acciones

---

## 4. Módulos funcionales (detalle completo)

## 4.1 Inventario (`/` → `HomePage.vue`)

Objetivo:

- Operar stock por artículo, talle y color.

Capacidades observadas:

- Selección de artículo por autocomplete
- Widget de alertas críticas de stock (`CriticalAlertsWidget`)
- Tabla de talles/colores con totales
- Alta/baja de stock en bloque (agregar/eliminar bombachas)
- Edición por talle
- Eliminación de talle completo (confirmación)
- Exportación a Excel (presente en lógica, botón comentado en template)
- Integración opcional con Google Drive (flujo de subida)

APIs relacionadas:

- `/api/articulos/listar`
- `/api/articulo/{id}`
- `/api/articulo/{id}/agregar-bombachas`
- `/api/articulo/{id}/eliminar-bombachas`
- `/api/articulo/{id}/editar-bombachas`
- `/api/articulo/{id}/eliminar-talle-completo`
- `/api/alertas/criticas`
- `/api/upload-to-drive`

---

## 4.2 Artículos (`/managearticulos` → `ManageArticulos.vue`)

Objetivo:

- ABM de artículos y configuración de reglas de precio/oferta/costos.

Capacidades:

- Búsqueda por nombre y número
- Vista y edición de datos por artículo
- Alta de artículo
- Eliminación de artículo
- Recalcular precios masivamente
- Configurar aumentos
- Ajustar costo original
- Configurar límites por tramos de precio
- Configurar ofertas por cantidad y tramos
- Configuración y gestión de cuotas
- Exportar artículos a Excel

APIs clave:

- `/api/articulos`
- `/api/articulo` (POST)
- `/api/articulo/{id}` (PUT/DELETE)
- `/api/articulos/recalcular-precios`
- `/api/articulos/aumentar-costos`
- `/api/articulos/ajustar-costo-original`
- `/api/articulos/revertir-ajuste-costo-original`
- `/api/articulos/configuracion-tramos` (+ CRUD)
- `/api/articulos/configuracion-ofertas-cantidad` (+ CRUD)
- `/api/articulos/configuracion-ofertas-cantidad/seed-inicial`
- `/api/cuotas` (+ CRUD)

---

## 4.3 Pedidos (`/managepedidos` → `ManagePedidos.vue`)

Objetivo:

- Cargar y mantener pedidos operativos por cliente/artículo/talle/colores.

Capacidades:

- Alta de pedido
- Edición y eliminación de pedidos
- Repetir pedido
- Variar colores
- Copiar pedidos como texto
- Exportar pedidos a Excel
- Importar pedidos desde Excel
- Reinicio de pedidos (confirmado)
- Cargar pedidos (confirmado)
- Soporte de query params para navegación contextual (ej. desde alertas)

APIs asociadas (indirectas desde componentes):

- Endpoints de artículos para combos (`/api/articulos/listar`)
- Endpoints de operaciones de pedido/venta según implementación del módulo

---

## 4.4 Clientes (`/clientes` → `Clientes.vue`)

Objetivo:

- Gestión de datos de clientes y vista de métricas de facturación/ventas.

Capacidades:

- Búsqueda de cliente
- Alta/edición/baja de cliente
- Visualización de columnas:
    - Nombre
    - Apellido
    - CUIT
    - CBU
    - Total Ventas
    - Total Pagado

APIs:

- `/api/clientes/listar`
- `/api/cliente` (POST)
- `/api/cliente/{id}` (PUT/DELETE)
- `/api/ventas/listar` (para consolidar métricas)

---

## 4.5 Ventas (`/ventas` → `Ventas.vue`)

Objetivo:

- Registrar ventas, manejar financiamiento/cuotas y facturación.

Capacidades observadas:

- Gestión de ventas con diálogo principal
- Venta regular y venta sin stock
- Edición individual y masiva
- Cambio de bombacha/producto
- Filtros y búsqueda (incluye por fecha)
- Diálogo de facturación
- Cálculo de cuotas/importe financiado
- Edición de selección múltiple
- Eliminación de venta
- KPIs/resúmenes de importes en pantalla

APIs:

- `/api/ventas` (POST registrar)
- `/api/ventas/sin-stock` (POST)
- `/api/ventas/listar` (GET)
- `/api/ventas/masivo` (PUT)
- `/api/ventas/{id}` (PUT/DELETE)
- `/api/ventas/cambiar-bombachas` (POST)
- `/api/facturaciones/guardar` (POST)
- `/api/facturaciones/ultima` (GET)

---

## 4.6 Calendario (`/comprascalendario` → `Calendario.vue`)

Objetivo:

- Agenda de compras/eventos con vista calendario.

Capacidades:

- Visualización con FullCalendar
- Alta/edición/baja de eventos
- Campos de evento:
    - Descripción
    - Nombre de persona
    - Fecha de compra
    - Hora inicio/fin
- Integración con datepicker y formatos de fecha

APIs:

- `/api/comprascalendario/listar`
- `/api/comprascalendario` (POST)
- `/api/comprascalendario/{id}` (PUT/DELETE)

---

## 4.7 Localidades (`/localidades` → `ManageLocalidades.vue`)

Objetivo:

- Administrar localidades y su disponibilidad operativa.

Capacidades:

- Búsqueda de localidad
- Alta/edición/baja
- Toggle de disponibilidad
- Exportación de listado a Excel
- Confirmación para borrado

APIs:

- `/api/localidades`
- `/api/localidad` (POST)
- `/api/localidad/{id}` (PUT/DELETE)

---

## 5. Alertas críticas de stock (dashboard)

Componente:

- `frontend/src/components/dashboard/CriticalAlertWidget.vue`

Función:

- Mostrar alertas críticas
- Ordenar/priorizar alertas
- Vincular alerta con pedido
- Marcar alerta como resuelta
- Navegar a pedido contextual por query params

APIs:

- `/api/alertas/criticas`
- `/api/alertas/{alert}/vincular-pedido`
- `/api/alertas/{alert}/marcar-resuelto`

---

## 6. Autenticación y seguridad de acceso

- Login en `/login`
- Token persistido en `localStorage` (`auth_token`)
- Guard de navegación en router:
    - Si ruta requiere auth y no hay token → `/login`
    - Validación de sesión vía `/api/check-auth`
- Logout limpia token y redirige al login

APIs auth:

- `/api/login`
- `/api/logout`
- `/api/check-auth`

---

## 7. Convenciones de UX operativa del proyecto

1. Operaciones destructivas siempre con confirmación
2. Formularios modales para ABM frecuentes
3. Exportación Excel en módulos administrativos
4. Feedback por toast/snackbar global
5. Navegación persistente por drawer
6. Uso de tablas para vista de volumen de datos

---

## 8. Lineamientos técnicos clave (para no romper el sistema)

- Respetar rutas y nombres de endpoints actuales
- Mantener `meta.requiresAuth` en rutas protegidas
- Preservar compatibilidad con cache sincronizada:
    - `useSyncedCache`
    - `cacheKeys`
    - `cacheEvents`
- No duplicar componentes si hay patrón reutilizable
- Mantener confirmaciones en acciones masivas/destructivas

---

## 9. Deuda técnica/documental detectada

1. README raíz y backend con contenido genérico de Laravel (falta documentación propia)
2. Funcionalidades presentes pero parcialmente comentadas en UI (ej. export drive en inventario)
3. Nombres históricos de archivos/rutas que no siempre reflejan dominio exacto
4. Falta guía operativa oficial unificada (este documento cubre ese vacío)

---

## 10. Roadmap sugerido de documentación interna

Fase 1 (rápida):

- Consolidar este archivo como “fuente única”
- Agregar diagrama simple de módulos y API

Fase 2:

- Manual operativo por perfil (administración / ventas)
- Catálogo de errores frecuentes y resolución

Fase 3:

- Estándares de UI y checklist de QA visual por pantalla
- Convenciones de naming y estructura frontend/backend

---

## 11. Glosario corto de dominios del sistema

- Artículo: producto base con número/nombre
- Talle: variante de tamaño
- Colores: stock por color en cada talle
- Pedido: solicitud previa (operativa comercial)
- Venta: operación confirmada con impacto económico
- Facturación: consolidación documental/comercial de ventas
- Localidad: zona operativa con disponibilidad
- Alerta crítica: señal de stock que requiere acción

---

## 12. Resumen ejecutivo

El Mensual ya tiene una base funcional sólida para operación comercial:

- Menú completo por dominios
- CRUDs principales implementados
- Integración de alertas de stock
- Flujos de ventas/facturación avanzados
- Exportación Excel en múltiples áreas

La prioridad estratégica es:

1. consolidar estándares visuales y de UX,
2. profesionalizar documentación viva del proyecto,
3. mantener consistencia técnica para escalar sin fricción.
