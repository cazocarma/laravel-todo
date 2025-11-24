# Laravel Todo App

Una aplicación sencilla de lista de tareas (Todo) desarrollada con **Laravel** en el backend, **Vue.js** en el frontend y **Tailwind CSS** para estilos. Contiene configuración para contenedores Docker, lo que facilita levantar un entorno completo en unos minutos.

## 🔍 ¿Qué incluye?

- Backend Laravel: control de rutas, modelo `Task`, migraciones, API RESTful.
- Frontend Vue.js: interfaz reactiva para listar, crear, editar y eliminar tareas.
- Tailwind CSS para estilos modernos, utilitarios y responsivos.
- Docker + Docker-Compose: configuración para PHP, MySQL/MariaDB y servidor web lista para producción/desarrollo.
- Buenas prácticas de código: estructura limpia, separación de responsabilidades, documentación mínima incorporada.
- Tests básicos (dependiendo de la versión del repositorio) para verificar funcionalidad clave.

## 🚀 Guía de instalación rápida

1. Clona el repositorio  
   ```bash
   git clone https://github.com/cazocarma/laravel-todo.git
   cd laravel-todo
   ```

2. Copia el archivo de entorno y ajusta variables

   ```bash
   cp .env.example .env
   # luego abre .env y edita por ejemplo APP_NAME, DB_DATABASE, DB_USERNAME, DB_PASSWORD, etc.
   ```

3. Construye y arranca los contenedores (si usas Docker)

   ```bash
   docker-compose up --build -d
   ```

4. Instala dependencias de Laravel y Vue.js

   ```bash
   docker compose exec <nombre_del_contenedor> composer install
   docker compose exec <nombre_del_contenedor> npm install
   docker compose exec <nombre_del_contenedor> npm run build
   ```

5. Ejecuta migraciones y generación de clave de aplicación

   ```bash
   docker compose exec <nombre_del_contenedor> php artisan key:generate
   docker compose exec <nombre_del_contenedor> php artisan migrate
   ```

6. Accede a la aplicación en el navegador

   ```text
   http://localhost:8000  # o el puerto que hayas configurado
   ```

## 🛠 Uso básico

* Crea una tarea en la interfaz.
* Marca una tarea como completada o elimínala.
* Edita una tarea existente.
* Usa filtros o vistas (si están implementados) para ver “todas”, “pendientes” o “completadas”.

## 🧩 Estructura del proyecto

```
├── app/                # Código backend de Laravel (modelos, controladores, etc.)
├── bootstrap/
├── config/
├── database/
│   ├── migrations/     # Migraciones para la base de datos
│   └── seeders/
├── public/             # Archivos públicos (frontend compilado, assets)
├── resources/
│   ├── js/             # Código Vue.js
│   └── css/            # Estilos Tailwind
├── routes/
│   └── web.php & api.php
├── tests/              # Tests automáticos
├── Dockerfile
├── docker-compose.yml
├── package.json
├── composer.json
└── README.md
```

## ✅ Buenas prácticas aplicadas

* Código modular y organizado: backend y frontend bien separados.
* Uso de utilitarios de Tailwind para CSS (menos estilos personalizados, más reutilización).
* Variables de entorno para configuraciones sensibles.
* Docker para replicabilidad del entorno de desarrollo/despliegue.
* Migraciones para control de esquema de bases de datos, facilitando evolución del proyecto.
* Dependencias actualizadas (en la medida de lo que el autor haya hecho).

## 🔧 Extensiones posibles

* Añadir autenticación de usuario para que cada uno tenga su propia lista de tareas.
* Implementar filtros avanzados (por usuario, por categoría, por fecha).
* Tests de integración frontend/backend más completos.
* Soporte para WebSockets / notificaciones en tiempo real cuando una nueva tarea se crea.
* Mejora de accesibilidad (a11y) y responsividad móvil.
* Migrar frontend a un stack más moderno si se desea (por ejemplo, reemplazar Vue por Angular o React).
* Integrar CI/CD (GitHub Actions) para tests automáticos y despliegues.

## 🎓 Para quién es este proyecto

Este proyecto es ideal:

* Como ejemplo de integración Laravel + Vue + Tailwind.
* Para desarrolladores que quieran clonar algo rápido y empezar a trabajar o personalizar.
* Para aprender sobre Docker en entornos de desarrollo web full-stack.
* Para quienes desean entender buenas prácticas en aplicaciones web sencillas.

## 📄 Licencia

Este proyecto se distribuye bajo la licencia **MIT**. Puedes libremente usar, modificar y distribuir el código según los términos de la MIT.

---

¡Gracias por revisar este proyecto! Si te sirve, considera dejar una estrella ⭐ en el repositorio y si haces mejoras o extensiones, puedes abrir un pull request o compartir tus ideas.

```