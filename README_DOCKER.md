# Backend API - Ruby on Rails con PostgreSQL

API REST desarrollada con Ruby on Rails 7 y PostgreSQL.
## Puertos Expuestos

- **Puerto 80**: Servidor web Rails
- **Puerto 5234**: PostgreSQL

## Requisitos

- Docker

## Instalación y Ejecución

### 1. Construir y levantar los contenedores

```bash
docker-compose up --build
```

### 2. Acceder a la aplicación

Una vez que los contenedores estén corriendo:

- API: http://localhost:80
- PostgreSQL: localhost:5234

### 3. Comandos útiles

**Detener los contenedores:**
```bash
docker-compose down
```

**Ver logs:**
```bash
docker-compose logs -f web
```

**Ejecutar comandos dentro del contenedor:**
```bash
docker-compose exec web bash
```

**Crear la base de datos:**
```bash
docker-compose exec web rails db:create
```

**Ejecutar migraciones:**
```bash
docker-compose exec web rails db:migrate
```

**Consola de Rails:**
```bash
docker-compose exec web rails console
```

**Ejecutar tests:**
```bash
docker-compose exec web rails test
```


## Configuración

Las variables de entorno están definidas en `docker-compose.yml`. Puedes crear un archivo `.env` basándote en `.env.example` para personalizar la configuración.

## Notas

- Los datos de PostgreSQL se persisten en un volumen de Docker
- El código se monta como volumen para desarrollo en caliente
- Las gemas se cachean en un volumen para acelerar las reconstrucciones
