---
name: ui-design-excellence
description: Guía operativa para diseñar y refinar interfaces de alta calidad visual y UX en este proyecto (Vue + Vuetify), manteniendo consistencia, accesibilidad, feedback de estado, responsive y estándares de componentes.
---

# Skill: UI Design Excellence (El Mensual)

## Cuándo usar esta skill

Usar esta skill cuando la tarea incluya cualquiera de estos objetivos:

- “Mejorar diseño” o “dejar más profesional una pantalla”
- Crear o refactorizar formularios, tablas, diálogos o dashboards
- Unificar estilos visuales entre menús
- Mejorar jerarquía visual, spacing, tipografía o uso de color
- Corregir problemas de responsive (mobile/tablet/desktop)
- Elevar UX de flujos críticos (ventas, pedidos, inventario)
- Diseñar nuevos componentes reutilizables de UI

## Objetivo

Conseguir una UI de nivel producción, consistente y clara para operación diaria, sin romper la lógica existente ni alterar comportamientos funcionales clave.

## Stack visual actual (contexto del proyecto)

- Frontend en Vue (SFC)
- Vuetify (componentes `v-`)
- Íconos Material Design
- Tablas reutilizables (`ResponsiveTable.vue`)
- Dialogs y flujos modales extensivos
- Snackbar global para feedback (`show-toast`, `v-snackbar` en `app.vue`)
- Menú lateral con navegación por rutas protegidas

## Principios de diseño que esta skill debe aplicar

### 1. Claridad operativa

El usuario principal opera inventario/ventas/pedidos rápido.  
Se prioriza:

- Lectura inmediata de estado
- Botones de acción principales siempre visibles
- Confirmaciones explícitas en operaciones destructivas

### 2. Consistencia visual

Todos los módulos deben compartir:

- Títulos con jerarquía homogénea
- Espaciado vertical consistente
- Botoneras con orden estable: primario → secundario → destructivo
- Iconografía coherente por tipo de acción

### 3. Densidad equilibrada

UI de gestión no debe quedar “vacía” ni saturada:

- Alta información, baja fricción
- Formularios segmentados por bloques
- Tablas escaneables con columnas estables

### 4. Feedback inmediato

Toda acción debe mostrar estado:

- Cargando / procesando
- Éxito
- Error legible y accionable

### 5. Accesibilidad y legibilidad

- Contraste suficiente
- Targets clickeables cómodos
- Labels claros y no ambiguos
- No depender solo del color para comunicar estado

## Checklist de ejecución (obligatorio)

### A. Auditoría rápida de pantalla

1. Identificar objetivo principal de la vista
2. Identificar acción primaria, secundaria y destructiva
3. Detectar inconsistencias visuales con otras vistas
4. Revisar mobile y desktop
5. Verificar feedback de estados (loading/error/success)

### B. Jerarquía visual

- Mantener un único título principal por vista
- Agrupar controles en bloques lógicos
- Respetar separación vertical regular (ej. 8/12/16/24)
- Evitar “botones huérfanos” sin contexto

### C. Componentización

- Si un patrón se repite, extraer componente reutilizable
- Evitar estilos duplicados por pantalla
- Centralizar tokens visuales (si aplica)

### D. Formularios

- Orden natural de campos
- Validación cercana al campo
- Placeholders de apoyo, no sustituyen labels
- Botón principal al final del flujo lógico

### E. Tablas

- Encabezados claros y consistentes
- Acciones por fila siempre en misma posición
- Filtros visibles arriba de la tabla
- Export/Import donde tenga sentido de negocio

### F. Diálogos

- Título específico de acción
- Botón de cancelar siempre claro
- Acción destructiva con warning explícito
- Cierre y estado posterior predecibles

### G. Responsive

- Validar al menos:
    - <768 (mobile)
    - 768-1024 (tablet)
    - > 1024 (desktop)
- Botones en columna en mobile cuando haga falta
- Evitar overflow horizontal no controlado

## Convenciones visuales recomendadas para El Mensual

### Acciones y colores

- Primaria: confirmar / guardar / registrar
- Secundaria: cancelar / cerrar
- Destructiva: eliminar / reiniciar
- Advertencia: operaciones masivas o irreversibles

### Iconografía

- Crear: `mdi-plus*`
- Editar: `mdi-pencil*`
- Eliminar: `mdi-delete*` / `mdi-trash*`
- Exportar: `mdi-download` / `mdi-file-excel`
- Configurar: `mdi-tune-variant` / `mdi-cog*`

### Microcopy

- Verbos directos: “Guardar”, “Editar”, “Eliminar”
- Confirmaciones con objeto explícito:
    - “¿Eliminar localidad?”
    - “¿Reiniciar todos los pedidos?”
- Errores explicados sin jerga técnica

## Reglas para cambios en este proyecto

1. No romper rutas existentes ni `meta.requiresAuth`
2. No romper cache sincronizada (`useSyncedCache`, `cacheEvents`)
3. Mantener coherencia con `ResponsiveTable.vue`
4. No introducir librerías visuales nuevas sin necesidad
5. Preservar flujos críticos actuales (ventas, pedidos, stock)

## Entregables esperados cuando se use esta skill

- Pantalla refinada visualmente (antes/después descrito)
- Lista de decisiones UX aplicadas
- Riesgos detectados (si los hay)
- Sugerencias de mejora incremental (fase 2)

## Definition of Done (DoD) de diseño

Se considera “excelente” cuando:

- Se entiende la pantalla en menos de 5 segundos
- Las acciones críticas se distinguen sin esfuerzo
- No hay inconsistencias obvias con el resto del sistema
- El flujo funciona bien en mobile y desktop
- Cada operación relevante muestra feedback al usuario
