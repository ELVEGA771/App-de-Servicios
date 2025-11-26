# Plan de Migración a Arquitectura Híbrida por Roles

## 🎯 Objetivo
Reorganizar el frontend Flutter usando un enfoque híbrido que separe la funcionalidad por roles (cliente/empresa) mientras mantiene código compartido en `core/`.

## 📊 Estructura Actual vs Propuesta

### Actual (Mezclada)
```
lib/
├── features/
│   ├── auth/
│   ├── home/              # ← Compartida, no clara
│   ├── empresa/           # ← Solo algunas pantallas
│   ├── servicio/          # ← ¿Cliente o empresa?
│   ├── profile/           # ← Compartida
│   ├── contratacion/      # ← ¿Cliente o empresa?
│   ├── chat/              # ← Compartida
│   ├── favoritos/         # ← Solo cliente
│   └── notificaciones/    # ← Compartida
```

### Propuesta (Híbrida)
```
lib/
├── core/                  # COMPARTIDO por todos
│   ├── models/
│   ├── services/
│   ├── providers/
│   ├── widgets/           # Widgets reutilizables
│   ├── utils/
│   └── theme/
│
├── features/
│   │
│   ├── auth/              # Login/Register COMÚN
│   │
│   ├── cliente/           # 🟢 TODO LO DE CLIENTE
│   │   ├── home/
│   │   ├── servicios/     # Buscar/Ver servicios
│   │   ├── contrataciones/ # Mis contrataciones
│   │   ├── favoritos/
│   │   ├── chat/
│   │   ├── perfil/
│   │   └── notificaciones/
│   │
│   └── empresa/           # 🔵 TODO LO DE EMPRESA
│       ├── home/
│       ├── servicios/     # Gestionar mis servicios
│       ├── sucursales/
│       ├── contrataciones/ # Ver solicitudes
│       ├── chat/
│       ├── perfil/
│       └── notificaciones/
│
├── routes/
│   ├── app_router.dart    # Router principal con guards
│   ├── cliente_routes.dart
│   └── empresa_routes.dart
│
└── main.dart
```

## 🔄 Mapeo de Archivos Existentes

### Auth (Compartido - NO MOVER)
- ✅ `features/auth/screens/splash_screen.dart`
- ✅ `features/auth/screens/login_screen.dart`
- ✅ `features/auth/screens/register_screen.dart`

### CLIENTE
| Archivo Actual | Nuevo Destino |
|---|---|
| `features/home/screens/home_screen.dart` | `features/cliente/home/screens/home_screen.dart` |
| `features/servicio/screens/servicio_list_screen.dart` | `features/cliente/servicios/screens/servicio_list_screen.dart` |
| `features/servicio/screens/servicio_search_screen.dart` | `features/cliente/servicios/screens/servicio_search_screen.dart` |
| `features/servicio/screens/servicio_detail_screen.dart` | `features/cliente/servicios/screens/servicio_detail_screen.dart` |
| `features/contratacion/screens/checkout_screen.dart` | `features/cliente/contrataciones/screens/checkout_screen.dart` |
| `features/contratacion/screens/order_history_screen.dart` | `features/cliente/contrataciones/screens/order_history_screen.dart` |
| `features/contratacion/screens/order_detail_screen.dart` | `features/cliente/contrataciones/screens/order_detail_screen.dart` |
| `features/contratacion/screens/order_tracking_screen.dart` | `features/cliente/contrataciones/screens/order_tracking_screen.dart` |
| `features/favoritos/screens/favoritos_screen.dart` | `features/cliente/favoritos/screens/favoritos_screen.dart` |
| `features/chat/screens/conversations_screen.dart` | `features/cliente/chat/screens/conversations_screen.dart` |
| `features/chat/screens/chat_screen.dart` | `features/cliente/chat/screens/chat_screen.dart` |
| `features/profile/screens/profile_screen.dart` | `features/cliente/perfil/screens/profile_screen.dart` |
| `features/profile/screens/edit_profile_screen.dart` | `features/cliente/perfil/screens/edit_profile_screen.dart` |
| `features/profile/screens/addresses_screen.dart` | `features/cliente/perfil/screens/addresses_screen.dart` |
| `features/profile/screens/add_address_screen.dart` | `features/cliente/perfil/screens/add_address_screen.dart` |
| `features/notificaciones/screens/notificaciones_screen.dart` | `features/cliente/notificaciones/screens/notificaciones_screen.dart` |

### EMPRESA
| Archivo Actual | Nuevo Destino |
|---|---|
| `features/empresa/screens/empresa_dashboard_screen.dart` | `features/empresa/home/screens/dashboard_screen.dart` |
| `features/empresa/screens/empresa_services_screen.dart` | `features/empresa/servicios/screens/services_list_screen.dart` |
| `features/empresa/screens/create_service_screen.dart` | `features/empresa/servicios/screens/create_service_screen.dart` |
| `features/empresa/screens/edit_service_screen.dart` | `features/empresa/servicios/screens/edit_service_screen.dart` |
| `features/empresa/screens/manage_sucursales_screen.dart` | `features/empresa/sucursales/screens/manage_sucursales_screen.dart` |
| `features/empresa/screens/create_sucursal_screen.dart` | `features/empresa/sucursales/screens/create_sucursal_screen.dart` |
| `features/empresa/screens/empresa_orders_screen.dart` | `features/empresa/contrataciones/screens/orders_screen.dart` |
| `features/chat/screens/conversations_screen.dart` | `features/empresa/chat/screens/conversations_screen.dart` (copiar) |
| `features/chat/screens/chat_screen.dart` | `features/empresa/chat/screens/chat_screen.dart` (copiar) |
| `features/profile/screens/profile_screen.dart` | `features/empresa/perfil/screens/profile_screen.dart` (adaptar) |
| `features/profile/screens/edit_profile_screen.dart` | `features/empresa/perfil/screens/edit_profile_screen.dart` (adaptar) |
| `features/notificaciones/screens/notificaciones_screen.dart` | `features/empresa/notificaciones/screens/notificaciones_screen.dart` (copiar) |

## 🏗️ Nuevos Archivos a Crear

### 1. Layouts por Rol
- `features/cliente/widgets/cliente_layout.dart`
- `features/empresa/widgets/empresa_layout.dart`

### 2. Bottom Navigation Bars
- `features/cliente/widgets/cliente_bottom_nav.dart`
- `features/empresa/widgets/empresa_bottom_nav.dart`

### 3. Drawers
- `features/cliente/widgets/cliente_drawer.dart`
- `features/empresa/widgets/empresa_drawer.dart`

### 4. Rutas
- `routes/app_router.dart` (usando go_router)
- `routes/cliente_routes.dart`
- `routes/empresa_routes.dart`

## 📋 Pasos de Implementación

### Fase 1: Preparación (NO romper nada)
1. ✅ Crear documento de planificación (este archivo)
2. ⏳ Crear nueva estructura de carpetas vacías
3. ⏳ Crear layouts y widgets base

### Fase 2: Implementación Incremental
4. ⏳ Copiar (NO mover) archivos a nueva estructura
5. ⏳ Actualizar imports en archivos copiados
6. ⏳ Crear nuevo sistema de rutas con `go_router`
7. ⏳ Implementar redirección automática por rol

### Fase 3: Migración
8. ⏳ Actualizar `main.dart` para usar nuevo router
9. ⏳ Probar navegación de cliente
10. ⏳ Probar navegación de empresa
11. ⏳ Eliminar archivos antiguos (SOLO cuando todo funcione)

### Fase 4: Optimización
12. ⏳ Extraer widgets compartidos a `core/widgets/`
13. ⏳ Implementar lazy loading por rol
14. ⏳ Optimizar temas por rol

## 🎨 Diseño de Navegación

### Cliente
```
SplashScreen → LoginScreen → ClienteHomeScreen
                                ↓
                    ClienteLayout (con drawer y bottomNav)
                         ↓
    ┌────────────────────┼────────────────────┐
    ↓                    ↓                    ↓
Servicios          Favoritos            Perfil
Contrataciones        Chat          Notificaciones
```

### Empresa
```
SplashScreen → LoginScreen → EmpresaHomeScreen
                                ↓
                    EmpresaLayout (con drawer y bottomNav)
                         ↓
    ┌────────────────────┼────────────────────┐
    ↓                    ↓                    ↓
Servicios          Sucursales           Perfil
Contrataciones        Chat          Notificaciones
```

## 🔒 Guards de Rutas

```dart
redirect: (context, state) {
  final authState = context.read<AuthProvider>();
  final isLoggedIn = authState.isAuthenticated;
  final userRole = authState.user?.tipoUsuario;

  // Si no está logueado
  if (!isLoggedIn && !state.location.startsWith('/login')) {
    return '/login';
  }

  // Si está logueado, redirigir según rol
  if (isLoggedIn && state.location == '/') {
    return userRole == 'cliente' ? '/cliente/home' : '/empresa/home';
  }

  // Proteger rutas de cliente
  if (state.location.startsWith('/cliente/') && userRole != 'cliente') {
    return '/empresa/home';
  }

  // Proteger rutas de empresa
  if (state.location.startsWith('/empresa/') && userRole != 'empresa') {
    return '/cliente/home';
  }

  return null;
}
```

## ⚠️ Consideraciones Importantes

### NO Romper el Código Existente
- Durante la migración, **ambos sistemas** coexistirán
- Solo cuando el nuevo sistema esté 100% funcional, eliminaremos el antiguo
- Usar feature flags si es necesario

### Widgets Compartidos
- `core/widgets/service_card.dart` - Usado por cliente y empresa
- `core/widgets/custom_button.dart` - Usado por todos
- `core/widgets/loading_indicator.dart` - Usado por todos

### Duplicación vs Reutilización
**Duplicar** cuando:
- La UI es específica del rol (dashboard empresa vs home cliente)
- La lógica difiere completamente

**Reutilizar** cuando:
- Es un componente visual genérico (botones, cards)
- Es un modelo de datos
- Es un servicio de API

## 📦 Dependencias Nuevas

```yaml
dependencies:
  go_router: ^13.0.0  # Para routing avanzado
```

## 🧪 Testing

### Tests a Crear
- `test/routes/route_guards_test.dart` - Validar redirecciones
- `test/features/cliente/home_test.dart` - Test navegación cliente
- `test/features/empresa/home_test.dart` - Test navegación empresa

## 📅 Cronograma Estimado

- **Fase 1**: 30 minutos (preparación)
- **Fase 2**: 2 horas (implementación)
- **Fase 3**: 1 hora (migración y testing)
- **Fase 4**: 1 hora (optimización)

**Total**: ~4.5 horas

## ✅ Checklist Final

Antes de merge:
- [ ] Todas las rutas de cliente funcionan
- [ ] Todas las rutas de empresa funcionan
- [ ] Guards redirigen correctamente
- [ ] Layouts se ven correctos
- [ ] No hay imports rotos
- [ ] Tests pasan
- [ ] Código antiguo eliminado

---

**Autor**: Plan de migración a arquitectura híbrida
**Fecha**: 2025
