# AGENTS.md — Enrutador principal de instrucciones para Codex (El Mensual)

Este archivo define cómo debe comportarse el agente en este repositorio y qué skills activar según el tipo de pedido.

## Objetivo

Reducir tiempo de contexto y garantizar respuestas consistentes para desarrollo, documentación y mejora de UX/UI.

---

## Skills disponibles del proyecto

### 1) ui-design-excellence

- Path sugerido: `/.codex/skills/ui-design-excellence/SKILL.md`
- Uso: mejoras de diseño, consistencia visual, UX, responsive, formularios, tablas, diálogos, jerarquía visual.

### 2) project-master-guide (documentación base)

- Path sugerido: `/docs/PROJECT_MASTER_GUIDE.md`
- Uso: consultas de arquitectura, menús, rutas, funcionalidades actuales, endpoints y convenciones del proyecto.

---

## Reglas de activación de skills

Activar `ui-design-excellence` cuando el usuario pida:

- mejorar diseño
- “dejarlo más prolijo/profesional”
- rehacer UI/UX
- unificar estilos
- refactor visual

Activar `project-master-guide` cuando el usuario pida:

- “explicame el proyecto”
- “documentame los menús”
- “qué hace cada módulo”
- “lineamientos generales”
- “estado actual del sistema”

Si el pedido mezcla ambos objetivos:

1. Cargar primero `project-master-guide` para contexto funcional
2. Luego aplicar `ui-design-excellence` para propuesta/ejecución visual

---

## Estándar de respuesta del agente en este repo

1. Explicar de forma directa y estructurada
2. Priorizar exactitud funcional sobre suposiciones
3. Si faltan datos, declarar supuestos explícitos
4. Dar pasos accionables y ordenados
5. Mantener lenguaje claro (evitar tecnicismo innecesario)

---

## Restricciones importantes

- No inventar funcionalidades no existentes sin marcarlo como propuesta
- No modificar contratos API sin advertencia explícita
- No romper flujo de autenticación ni navegación protegida
- Mantener consistencia con componentes compartidos y utilidades de cache

---

## Convención de salida recomendada

Cuando se pida documentación:

- Resumen ejecutivo
- Arquitectura y stack
- Menús/rutas
- Flujo funcional por módulo
- Integración frontend-backend
- Checklist de operación
- Riesgos y deuda técnica (si aplica)

Cuando se pida mejora visual:

- Diagnóstico UI/UX actual
- Propuesta de mejora por bloques
- Cambios priorizados (rápidos vs estructurales)
- Criterios de aceptación visual y funcional
