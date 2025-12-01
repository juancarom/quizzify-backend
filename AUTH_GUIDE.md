# Autenticación y Autorización - Quizzify API

## Sistema de Autenticación

La API utiliza **Devise** con **JWT** para autenticación basada en tokens y **OmniAuth** para login con Google.

### Endpoints de Autenticación

#### Registro de Usuario
```bash
POST /signup
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "name": "Juan Pérez"
  }
}
```

**Respuesta exitosa (200):**
```json
{
  "status": {
    "code": 200,
    "message": "Usuario creado exitosamente."
  },
  "data": {
    "id": 1,
    "email": "user@example.com",
    "name": "Juan Pérez",
    "role": "user"
  }
}
```

#### Login
```bash
POST /login
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password123"
  }
}
```

**Respuesta exitosa (200):**
```json
{
  "status": {
    "code": 200,
    "message": "Usuario logueado exitosamente."
  },
  "data": {
    "id": 1,
    "email": "user@example.com",
    "name": "Juan Pérez",
    "role": "user"
  }
}
```

**Headers de respuesta incluyen:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

#### Logout
```bash
DELETE /logout
Authorization: Bearer YOUR_JWT_TOKEN
```

#### Login con Google

1. **Redireccionar al usuario a:**
```
GET /users/auth/google_oauth2
```

2. **Google redireccionará de vuelta a:**
```
/users/auth/google_oauth2/callback
```

## 🛡️ Sistema de Autorización

Utiliza **CanCanCan** para gestionar permisos basados en roles.

### Roles Disponibles

1. **Admin** - Acceso completo a todos los recursos
2. **Teacher** - Puede crear y gestionar sus propios quizzes
3. **User** (default) - Puede ver quizzes y realizar intentos

### Verificar Permisos en Controladores

```ruby
class QuizzesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    # Solo muestra quizzes que el usuario puede ver
    @quizzes
  end

  def create
    # Solo si el usuario tiene permiso para crear
    @quiz.save
  end
end
```

### Configuración de Google OAuth2

1. **Crear credenciales en Google Cloud Console:**
   - Ir a https://console.cloud.google.com/
   - Crear un nuevo proyecto o seleccionar uno existente
   - Habilitar Google+ API
   - Crear credenciales OAuth 2.0
   - Configurar URLs autorizadas:
     - http://localhost:80
     - http://localhost:80/users/auth/google_oauth2/callback

2. **Agregar credenciales al `.env`:**
```env
GOOGLE_CLIENT_ID=tu_client_id_de_google
GOOGLE_CLIENT_SECRET=tu_client_secret_de_google
```

3. **Reconstruir el contenedor:**
```bash
docker-compose down
docker-compose up --build
```

## Uso del Token JWT

### En cada request autenticado, incluir el header:
```
Authorization: Bearer YOUR_JWT_TOKEN
```

### Ejemplo con cURL:
```bash
curl -X GET http://localhost:80/api/quizzes \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..." \
  -H "Content-Type: application/json"
```

### Ejemplo con JavaScript (fetch):
```javascript
fetch('http://localhost:80/api/quizzes', {
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
})
```

## Flujo de Autenticación Completo

1. Usuario se registra o hace login → Recibe JWT token
2. Cliente guarda el token (localStorage, cookies, etc.)
3. Cliente incluye token en header `Authorization` en cada request
4. Servidor valida token y carga usuario actual
5. CanCanCan verifica permisos del usuario para la acción solicitada
6. Si está autorizado → Procesa request
7. Si no está autorizado → Retorna 403 Forbidden

## Notas Importantes

- Los tokens JWT expiran después de 1 día
- Los tokens revocados se almacenan en la tabla `jwt_denylist`
- El password debe tener mínimo 6 caracteres
- Los usuarios de Google OAuth2 reciben un password aleatorio
- El rol por defecto es 'user'
