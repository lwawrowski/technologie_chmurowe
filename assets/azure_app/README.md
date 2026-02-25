# Hello World - Aplikacja z Docker Compose

Prosta aplikacja "Hello World" składająca się z trzech kontenerów Docker.

## Struktura

- **Frontend** - statyczna strona HTML serwowana przez nginx
- **Backend** - API w Pythonie (Flask) zwracające JSON
- **Nginx** - reverse proxy kierujący ruch do odpowiednich serwisów

## Uruchomienie

```bash
docker-compose up --build
```

## Dostęp

- Aplikacja: http://localhost:8080
- Backend (bezpośrednio): http://localhost:5000/api/hello

## Zatrzymanie

```bash
docker-compose down
```

## Architektura

```
Przeglądarka
    ↓
Nginx (port 8080)
    ├─→ / → Frontend (nginx:80)
    └─→ /api → Backend (Flask:5000)
```
