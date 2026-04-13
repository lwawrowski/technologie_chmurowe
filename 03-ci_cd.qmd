# CI/CD - Plan zajęć warsztatowych

## Cel zajęć
- Zrozumienie koncepcji CI/CD i jej znaczenia w nowoczesnym developmencie
- Praktyczna nauka tworzenia pipeline'ów w GitHub Actions
- Automatyzacja testowania, budowania i wdrażania aplikacji
- Integracja CI/CD z Azure i Docker
- Przygotowanie do implementacji CI/CD w projekcie końcowym

---

## 1. Wprowadzenie teoretyczne (15 min)

### Czym jest CI/CD?

#### Continuous Integration (CI) - Ciągła Integracja

**Definicja:**
- Automatyczne łączenie kodu z wielu deweloperów do wspólnego repozytorium
- Każda zmiana (commit) uruchamia automatyczne budowanie i testowanie
- Błędy wykrywane są **natychmiast**, nie po tygodniach

**Przykład bez CI:**
```
Developer A pracuje 2 tygodnie → commit
Developer B pracuje 2 tygodnie → commit
❌ Merge conflict! Kod się nie kompiluje!
🔥 Całe zespół stoi 2 dni
```

**Przykład z CI:**
```
Developer A: commit → ✅ testy przeszły → merge
Developer B: commit → ❌ testy nie przeszły → natychmiastowa naprawa
✅ Kod zawsze działa
```

**Kluczowe elementy CI:**
1. **Automatyczne testy** przy każdym commit
2. **Automatyczne budowanie** aplikacji
3. **Szybki feedback** - wiesz w 5 minut czy coś zepsułeś
4. **Merge często** - małe zmiany, łatwiejsze łączenie

---

#### Continuous Deployment/Delivery (CD) - Ciągłe Wdrażanie

**Continuous Delivery:**
- Kod **gotowy do wdrożenia** w każdej chwili
- Wdrożenie wymaga manualnego zatwierdzenia (przycisk "Deploy")

**Continuous Deployment:**
- Kod **automatycznie wdrażany** na produkcję po przejściu testów
- Zero manualnej interwencji

**Przykład pipeline CD:**
```
1. Commit do main → CI testy ✅
2. ⬇️ Automatyczne budowanie obrazu Docker
3. ⬇️ Push do Azure Container Registry
4. ⬇️ Deploy na środowisko staging → testy E2E
5. ⬇️ [OPCJONALNIE: Manual approval]
6. ⬇️ Deploy na produkcję
```

---

### 🎯 Korzyści CI/CD

#### Dla pojedynczego developera:
- ✅ **Automatyzacja nudnych zadań** (budowanie, deploy)
- ✅ **Pewność że kod działa** przed wdrożeniem
- ✅ **Łatwiejsze łapanie bugów** - testy przy każdym commit
- ✅ **Historia zmian** - każdy build logowany

#### Dla zespołu:
- ✅ **Szybsze wykrywanie konfliktów** między developerami
- ✅ **Standardowy proces** - wszyscy deployują tak samo
- ✅ **Mniej stresujące wdrożenia** - częste, małe zmiany
- ✅ **Rollback w minutę** jeśli coś pójdzie nie tak

#### Dla projektu końcowego:
- ✅ **Wymaganie kursu** - projekt musi mieć CI/CD!
- ✅ **Imponujące w portfolio** - pokazuje profesjonalizm
- ✅ **Łatwiejsze testowanie** - automatyczne testy przy zmianach
- ✅ **Szybsze iteracje** - zmiana → test → deploy w minuty

---

### GitHub Actions - narzędzie CI/CD

#### Co to jest GitHub Actions?

- **Wbudowane w GitHub** - nie trzeba zakładać konta w CircleCI/Jenkins
- **Darmowe dla publicznych repo** - 2000 minut/miesiąc dla prywatnych
- **Łatwe w nauce** - pliki YAML w folderze `.github/workflows/`
- **Integracja z Azure** - oficjalne akcje od Microsoft

#### Podstawowe pojęcia:

**Workflow:**
- Zautomatyzowany proces (plik `.github/workflows/ci.yml`)
- Może być wiele workflow'ów w jednym projekcie

**Trigger (Event):**
- Co uruchamia workflow: `push`, `pull_request`, `schedule`, `manual`

**Job:**
- Zestaw kroków wykonywanych na jednym runner'ze
- Joby mogą działać równolegle lub sekwencyjnie

**Step:**
- Pojedyncza akcja: uruchom komendę, wykonaj gotową akcję

**Runner:**
- Maszyna wirtualna która wykonuje workflow (Ubuntu, Windows, macOS)

**Przykład struktury:**
```yaml
name: CI Pipeline            # Nazwa workflow
on: [push, pull_request]     # Trigger

jobs:                        # Lista jobów
  test:                      # Nazwa joba
    runs-on: ubuntu-latest   # Runner
    steps:                   # Kroki
      - uses: actions/checkout@v3     # Gotowa akcja
      - run: npm test                 # Komenda
```

---

### Kontekst projektu końcowego

**Wymagania projektu:**
- ✅ **Aplikacja CRUD** - backend API + frontend
- ✅ **Wdrożenie w chmurze** (Azure)
- ✅ **CI/CD pipeline** - automatyczne testy i deploy ⬅️ **DZISIAJ**
- ✅ **Bezpieczeństwo** - HTTPS, szyfrowane hasła
- ✅ **Architektura mikrousług** - min 2 serwisy
- ✅ **Testy** - jednostkowe + E2E ⬅️ **DZISIAJ**

**Co zbudujemy dzisiaj:**
- Pipeline testujący backend (Python/Flask)
- Budowanie obrazów Docker
- Push do Azure Container Registry (ACR)
- Automatyczny deploy na Azure
- Secrets management (bezpieczne przechowywanie haseł)

**Bazowy projekt:** `azure_app_2`
- Backend (Flask + PostgreSQL + Blob Storage)
- Frontend (HTML/JS)
- Nginx (reverse proxy)
- Wszystko w Docker Compose

---

## 2. ĆWICZENIE 1: Pierwszy workflow - Testy backend (20 min)

### 🎯 Cel: Uruchomienie testów jednostkowych przy każdym commit

### Krok 1: Przygotowanie repozytorium

**1.1. Stwórz nowe repo na GitHub:**
- Przejdź na https://github.com i zaloguj się
- Kliknij "+" -> **"New repository"**
- **Repository name:** `azure_app_2` (lub inna nazwa)
- **Visibility:** Public (więcej darmowych minut Actions)
- **Create repository**

**1.2. Pobierz azure_app_2 z repo technologie_chmurowe i zamień na nowe repo**

```bash
# sklonuj projekt
git clone https://github.com/lwawrowski/technologie_chmurowe.git

# przejdź do tego repo
cd technologie_chmurowe

# utwórz nowy branch (o nazwie azure_app_2) z folderu azure_app_2
git subtree split --prefix="assets/azure_app_2" -b azure_app_2

# połącz lokalny projekt ze swoim repo na GitHub
git remote add new-origin https://github.com/<link do repo>

# push do nowego repo - teraz powinien być tam tylko folder azure_app_2
git push new-origin azure_app_2:main
```

**1.3. Sprawdź czy projekt jest na GitHub:**
- Odśwież stronę repozytorium
- Powinieneś zobaczyć foldery: `backend/`, `frontend/`, `nginx/`


**1.4. Pobierz projekt z GitHub**

- przejdź do lokalizacji gdzie chcesz dodać nowy projekt
- Pobierz z repozytorium https lub ssh
  
```bash

# sklonuj repo lokalnie
git clone https://github.com/<uzytkownik>/<nazwa projektu>

```

---

### Krok 2: Dodanie testów jednostkowych do backendu

**2.1. Struktura projektu backend:**
```
backend/
├── app.py              # Główna aplikacja Flask
├── Dockerfile
├── requirements.txt
└── tests/              # ⬅️ NOWY FOLDER
    ├── __init__.py
    └── test_api.py     # Testy jednostkowe
```

**2.2. Utwórz folder testów:**
```bash
mkdir backend/tests

# utwórz __init__ zeby pytest znalazł testy
touch backend/tests/__init__.py

```

**2.3. Utwórz plik `backend/tests/test_api.py`:**
```python
import pytest
import sys
import os
from unittest.mock import MagicMock, patch

# Dodaj parent directory do sys.path aby zaimportować app
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

@pytest.fixture
def client():
    """Fixture tworzący test client Flask"""
    from app import app
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_hello_endpoint(client):
    """Test endpointa /api/hello - sprawdza czy API odpowiada poprawnie"""
    response = client.get('/api/hello')
    
    assert response.status_code == 200
    data = response.get_json()
    assert data['message'] == 'Hello World from Backend!'
    assert data['status'] == 'success'


def test_add_user_validation(client):
    """Test walidacji - dodawanie usera bez wymaganych pól powinno zwrócić błąd 400"""
    # Próba dodania usera bez surname
    response = client.post('/api/db/users', json={'name': 'Jan'})
    
    assert response.status_code == 400
    data = response.get_json()
    assert data['status'] == 'error'
    assert 'required' in data['error'].lower()


@patch('app.get_db_connection')
def test_get_users_with_mock_db(mock_db, client):
    """Test pobierania użytkowników z zamockowaną bazą danych"""
    # Przygotowanie mocka bazy danych
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_db.return_value = mock_conn
    mock_conn.cursor.return_value = mock_cursor
    
    # Symulacja danych z bazy
    mock_cursor.fetchall.return_value = [
        (1, 'Jan', 'Kowalski', '2024-01-01 12:00:00'),
        (2, 'Anna', 'Nowak', '2024-01-02 13:00:00')
    ]
    
    response = client.get('/api/db/users')
    
    assert response.status_code == 200
    data = response.get_json()
    assert data['status'] == 'success'
    assert len(data['users']) == 2
    assert data['users'][0]['name'] == 'Jan'
    assert data['users'][1]['name'] == 'Anna'
    
```

**2.4. Dodaj pytest do requirements:**
```bash
# Dodaj na końcu backend/requirements.txt
echo "pytest==7.4.3" >> backend/requirements.txt
echo "pytest-cov==4.1.0" >> backend/requirements.txt
```

**2.5. Przetestuj lokalnie (opcjonalnie):**

**Opcja A: Z Dockerem (rekomendowane - nie instaluje nic na komputerze):**
```bash
# Zbuduj obraz backendu (pamiętaj o wcześniejszym uruchomieniu docker desktop)
docker build -t backend-test ./backend

# Uruchom testy w kontenerze
docker run --rm backend-test pytest tests/ -v

# Powinieneś zobaczyć:
# tests/test_api.py::test_import PASSED                                    [ 25%]
# tests/test_api.py::test_basic_math PASSED                                [ 50%]
# tests/test_api.py::test_string_operations PASSED                         [ 75%]
# tests/test_api.py::test_flask_app_exists PASSED                          [100%]
```

---

### Krok 3: Pierwszy workflow CI

**3.1. Utwórz strukturę folderów dla GitHub Actions:**
```bash
# W głównym katalogu projektu (azure-app-cicd/)
mkdir -p .github/workflows
```

**3.2. Utwórz plik `.github/workflows/ci.yml`:**
```yaml
name: CI - Backend Tests

# Kiedy uruchomić workflow
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test-backend:
    name: Test Backend API
    runs-on: ubuntu-latest
    
    steps:
      # Krok 1: Pobierz kod z repo
      - name: Checkout code
        uses: actions/checkout@v3
      
      # Krok 2: Zainstaluj Python
      - name: Setup Python 3.11
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      # Krok 3: Zainstaluj zależności
      - name: Install dependencies
        run: |
          cd backend
          pip install --upgrade pip
          pip install -r requirements.txt
      
      # Krok 4: Uruchom testy
      - name: Run tests with pytest
        run: |
          cd backend
          pytest tests/ -v --cov=. --cov-report=term-missing
      
      # Krok 5: Raport z testów (opcjonalnie)
      - name: Test Summary
        if: always()
        run: |
          echo "✅ Backend tests completed!"
```

**3.3. Commit i push:**
```bash
git add .
git commit -m "Add CI workflow for backend tests"
git push origin main
```

---

### Krok 4: Sprawdzenie wyniku

**4.1. Zobacz workflow w akcji:**
- Przejdź do swojego repo na GitHub
- Kliknij zakładkę **"Actions"** (góra strony)
- Powinieneś zobaczyć workflow **"CI - Backend Tests"** w trakcie wykonywania

**4.2. Obserwuj wykonanie:**
- Kliknij na nazwę workflow
- Kliknij na job **"Test Backend API"**
- Zobacz poszczególne kroki wykonywane live!

**4.3. Weryfikacja:**
- ✅ Wszystkie kroki zielone? **Sukces!**
- ❌ Coś czerwone? Kliknij i zobacz logi błędu

**4.4. Badge statusu (opcjonalnie):**
Dodaj do `README.md`:
```markdown
# Azure App CI/CD

![CI Status](https://github.com/TWOJA-NAZWA/NAZWA-PROJEKTU/workflows/CI%20-%20Backend%20Tests/badge.svg)
```

---

### 🧪 Eksperyment: Symulacja błędu

**Celowo wprowadź błąd i zobacz jak CI go wykrywa:**

1. Zmień test w `backend/tests/test_api.py` - zmodyfikuj `test_hello_endpoint`:
```python
def test_hello_endpoint(client):
    """Test endpointa /api/hello - sprawdza czy API odpowiada poprawnie"""
    response = client.get('/api/hello')
    
    assert response.status_code == 200
    data = response.get_json()
    assert data['message'] == 'Wrong Message!'  # ⬅️ Celowy błąd!
    assert data['status'] == 'success'
```

2. Przetestuj lokalnie z Dockerem (opcjonalnie):
```bash
docker build -t backend-test ./backend
docker run --rm backend-test pytest tests/ -v
# Powinieneś zobaczyć błąd: AssertionError
```

3. Commit i push:
```bash
git add backend/tests/test_api.py
git commit -m "Test: symulacja błędu w testach"
git push
```

4. Przejdź do **Actions** → sprawdź że workflow **failuje ❌**

5. Napraw i push ponownie:
```python
def test_hello_endpoint(client):
    """Test endpointa /api/hello - sprawdza czy API odpowiada poprawnie"""
    response = client.get('/api/hello')
    
    assert response.status_code == 200
    data = response.get_json()
    assert data['message'] == 'Hello World from Backend!'  # ✅ Naprawione
    assert data['status'] == 'success'
```

---

## 3. ĆWICZENIE 2: Build i push Docker images do ACR (20 min)

### 🎯 Cel: Automatyczne budowanie i wysyłanie obrazów Docker do Azure Container Registry

### Krok 1: Utworzenie Azure Container Registry (jeśli jeszcze nie masz)

**Przez Azure CLI:**
```bash
# Zaloguj się do Azure
az login

# Utwórz ACR (wybierz unikalną nazwę)
az acr create \
  --resource-group technologie-chmurowe-rg \
  --name <twojanazvvaacr> \
  --sku Basic \
  --location polandcentral

# Włącz admin access (łatwiejsze logowanie z GitHub Actions)
az acr update --name <twojanazvvaacr> --admin-enabled true

# Pobierz credentials (ZAPISZ JE!)
az acr credential show --name <twojanazvvaacr>
```

---

### Krok 2: Dodanie Secrets do GitHub

**Secrets to bezpieczne zmienne dostępne tylko w workflow.**

**2.1. Przejdź do ustawień repo:**
- GitHub repo → **"Settings"** → **"Secrets and variables"** → **"Actions"**
- Kliknij **"New repository secret"**

**2.2. Dodaj 3 secrety:**

**Secret 1:**
- **Name:** `ACR_LOGIN_SERVER`
- **Value:** `<twojanazvvaacr>.azurecr.io`

**Secret 2:**
- **Name:** `ACR_USERNAME`
- **Value:** `<username z Access keys>` ("username" a nie "name"!!! jeśli wklejasz tutaj "password" to jest źle)

**Secret 3:**
- **Name:** `ACR_PASSWORD`
- **Value:** `<password z Access keys>`

**2.3. Sprawdź:**
- Powinieneś widzieć 3 secrety w liście
- Wartości są ukryte (***) - nie można ich odczytać!

---

### Krok 3: Workflow budowania i push do ACR

**3.1. Utwórz nowy plik `.github/workflows/docker-build.yml`:**
```yaml
name: Docker Build & Push

on: #uruchamianie
  push: # przy pushowaniu 
    branches: [ main ] # na maina
  workflow_dispatch:  # + możliwość manualnego uruchomienia

jobs: # co robi po uruchomieniu:
  build-and-push:
    name: Build Docker Images
    runs-on: ubuntu-latest # uruchamia maszynę wirtualną na GitHub z ubuntu
    
    steps:
      - name: Checkout code # pobiera kod z repozytorium (main)
        uses: actions/checkout@v3
      
      # Set up Docker Buildx - konfiguruje Docker Buildx, zaawansowany builder Docker, który:
      # - Wspiera budowanie wieloplatformowe (ARM, x86)
      # - Umożliwia efektywne cachowanie warstw
      # - Pozwala na równoległe budowanie obrazów
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Log in to Azure Container Registry # logowanie do ACR przy pomocy sekretów
        uses: docker/login-action@v2
        with:
          registry: ${{ secrets.ACR_LOGIN_SERVER }}
          username: ${{ secrets.ACR_USERNAME }}
          password: ${{ secrets.ACR_PASSWORD }}
      
      # Budowanie obrazów dla każdego serwisu:
      #   - `context: ./backend` - wskazuje folder z Dockerfile i kodem
      #   - `push: true` - automatycznie publikuje obraz do ACR po zbudowaniu
      #   - `tags` - przypisuje DWIE etykiety do każdego obrazu:
      #     - `latest` - zawsze pokazuje najnowszą wersję (łatwe wdrożenie)
      #     - `${{ github.sha }}` - unikalny hash commita (np. `abc123def`) umożliwiający rollback do konkretnej wersji
      #   - `cache-from` i `cache-to` - wykorzystuje cache z poprzednich buildów aby przyspieszyć budowanie (wykorzystuje już pobrane warstwy bazowe)

      - name: Build and push Backend image
        uses: docker/build-push-action@v4
        with:
          context: ./backend
          push: true
          tags: |
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:latest
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:${{ github.sha }}
          cache-from: type=registry,ref=${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:latest
          cache-to: type=inline
      
      - name: Build and push Frontend image
        uses: docker/build-push-action@v4
        with:
          context: ./frontend
          push: true
          tags: |
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-frontend:latest
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-frontend:${{ github.sha }}
      
      - name: Build and push Nginx image
        uses: docker/build-push-action@v4
        with:
          context: ./nginx
          push: true
          tags: |
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-nginx:latest
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-nginx:${{ github.sha }}
      
      - name: Images pushed successfully # wypisuje podsumowanie z nazwami opublikowanych obrazów
        run: |
          echo "✅ All images pushed to ACR!"
          echo "Backend: ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:latest"
          echo "Frontend: ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-frontend:latest"
          echo "Nginx: ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-nginx:latest"
```

---

**3.2. Commit i push:**
```bash
git add .github/workflows/docker-build.yml
git commit -m "Add Docker build and push workflow"
git push origin main
```

**3.3. Sprawdź wykonanie:**
- GitHub → **"Actions"** → workflow **"Docker Build & Push"**
  
---

### Krok 4: Weryfikacja w Azure

**4.1. Sprawdź czy obrazy są w ACR:**

**Przez CLI:**
```bash
# Wylistuj obrazy w ACR
az acr repository list --name <twojanazvvaacr> --output table

# Powinieneś zobaczyć:
# azure-app-backend
# azure-app-frontend
# azure-app-nginx
```

**Przez Portal:**
1. Azure Portal → Twój ACR
2. **"Services"** → **"Repositories"**
3. Powinieneś zobaczyć 3 repozytoria z obrazami
4. Kliknij na obraz → zobacz tagi (`latest`, `<commit-sha>`)

---




## Krok 1: Utwórz Azure App Service

Najprościej zrób to przez Azure Portal.

1. Wejdź do Azure Portal.
2. Wyszukaj `App Services`.
3. Kliknij `Create` -> `Web App`.
4. Ustaw:
   - `Resource Group`: `technologie-chmurowe-rg`
   - `Name`: np. `azure-app-cicd-666` lub inna unikalna nazwa
   - `Publish`: `Container`
   - `Operating System`: `Linux`
   - `Region`: `Poland Central`
   - `Pricing plan`: `B1`

Uwagi:
- `Free F1` zwykle nie nadaje się sensownie do kontenerów.
- Nazwa aplikacji musi być globalnie unikalna.

5. W zakładce `Container` **wyłącz** opcję `Sidecar support`.
6. Przejdź przez wszysktie zakładki i zostaw domyślne ustawienia -> wybierz `Create` i poczekaj az aplikacja powstanie.
   
Po utworzeniu zapamiętaj adres:
`https://<nazwa-aplikacji>.azurewebsites.net`

---

## Krok 2: Pobierz Publish Profile

1. Otwórz utworzony App Service.
2. Wejdź w Settings → Configuration
3. Otwórz zakładkę General settings
4. Znajdź sekcję Platform settings
5. Włącz:
   - SCM Basic Auth Publishing Credentials
   - FTP Basic Auth Publishing Credentials
   - Kliknij Save.
6. Kliknij `Overview`.
7. Kliknij `Download publish profile`, moze być ukryty pod symbolem `...` (dzięki krokom 2-5 jest to teraz mozliwe)
8. Pobierze się plik `.PublishSettings`.

---

## Krok 3: Dodaj sekret do GitHub

W repozytorium GitHub wejdź w:

`Settings` → `Secrets and variables` → `Actions`

Dodaj dwa sekrety:

**Secret 1**
- Name: `AZURE_WEBAPP_PUBLISH_PROFILE`
- Value: cała zawartość pobranego pliku publish profile

**Secret 2**
- Name: `AZURE_WEBAPP_NAME`
- Value: nazwa Twojej aplikacji App Service, np. `azure-app-cicd-xyz`

---

## Krok 4: Skonfiguruj App Service do pobierania obrazów z ACR

Ćwiczenie 2 już kazało dodać do GitHub:
- `ACR_LOGIN_SERVER`
- `ACR_USERNAME`
- `ACR_PASSWORD`

Teraz te same dane trzeba ustawić także w App Service, bo to Azure będzie pobierał obrazy z prywatnego ACR.

W Azure Portal:
1. Otwórz App Service.
2. Wejdź w `Settings` → `Environment variables`.
3. Dodaj:

- `DOCKER_REGISTRY_SERVER_URL` = `https://<twoj-acr>.azurecr.io` (do sprawdzenia w Overview w utworzonym ACR)
- `DOCKER_REGISTRY_SERVER_USERNAME` = `<ACR_USERNAME>` (do sprawdzenia w Settings -> Access keys w utworzonym ACR)
- `DOCKER_REGISTRY_SERVER_PASSWORD` = `<ACR_PASSWORD>`

---

## Krok 5: Dodaj zmienne środowiskowe aplikacji

Backend w app.py i app.py używa:
- `DATABASE_URL`
- `AZURE_STORAGE_CONNECTION_STRING`
- `AZURE_STORAGE_CONTAINER`
Powyzsze zmienne trzeba znaleźć u siebie na komputerze w pliku .env w folderze projektu. 

W App Service, w `Settings` → `Environment variables`, dodaj:

- `DATABASE_URL`
- `AZURE_STORAGE_CONNECTION_STRING`
- `AZURE_STORAGE_CONTAINER`

Na tym etapie wpisz tam zwykłe wartości ręcznie.
To jest ważne, bo dzięki temu ćwiczenie 4 nadal będzie możliwe: później po prostu podmienisz wartości tych samych zmiennych na referencje do Key Vault.

---

## Krok 6: Przygotuj plik compose do App Service

Utwórz w repo plik `docker-compose.appservice.yml` z taką zawartością:

```yaml
version: '3.8'

services:
  backend:
    image: <twoj-acr>.azurecr.io/azure-app-backend:latest
    environment:
      DATABASE_URL: ${DATABASE_URL}
      AZURE_STORAGE_CONNECTION_STRING: ${AZURE_STORAGE_CONNECTION_STRING}
      AZURE_STORAGE_CONTAINER: ${AZURE_STORAGE_CONTAINER}

  frontend:
    image: <twoj-acr>.azurecr.io/azure-app-frontend:latest

  nginx:
    image: <twoj-acr>.azurecr.io/azure-app-nginx:latest
    ports:
      - "80:80"
    depends_on:
      - backend
      - frontend
```

Ważne:
- zamień `<twoj-acr>` na prawdziwą nazwę ACR,
- zostaw obrazy `azure-app-backend`, `azure-app-frontend`, `azure-app-nginx`, bo tak były zbudowane w ćwiczeniu 2,
- wystawiony port ma być tylko na `nginx`,
- to jest zgodne z routingiem z nginx.conf.

---

## Krok 7: Workflow deploymentu

Utwórz plik `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Azure App Service

on:
  workflow_run:
    workflows: ["Docker Build & Push"]
    types:
      - completed
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    name: Deploy multi-container app
    runs-on: ubuntu-latest
    if: ${{ github.event_name == 'workflow_dispatch' || github.event.workflow_run.conclusion == 'success' }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Deploy docker compose to Azure Web App
        uses: azure/webapps-deploy@v3
        with:
          app-name: ${{ secrets.AZURE_WEBAPP_NAME }}
          publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}
          configuration-file: docker-compose.appservice.yml
```

Dlaczego tak:
- workflow odpala się po sukcesie z ćwiczenia 2,
- nie używa `azure/login`,
- nie potrzebuje `AZURE_CREDENTIALS`,
- nie potrzebuje `Service Principal`.

---

## Krok 8: Commit i push

```bash
git add docker-compose.appservice.yml .github/workflows/deploy.yml
git commit -m "Add App Service deployment workflow"
git push origin main
```

---

## Krok 9: Weryfikacja

Po pushu sprawdź w GitHub Actions:
1. `CI - Backend Tests`
2. `Docker Build & Push`
3. `Deploy to Azure App Service`

Po zakończeniu wejdź na:

```text
https://<twoja-aplikacja>.azurewebsites.net
```

Health check sprawdzisz pod:

```text
https://<twoja-aplikacja>.azurewebsites.net/api/health
```

To powinno zwrócić odpowiedź zgodną z app.py:

```json
{"status":"healthy"}
```

---

## Typowe problemy

### 1. App Service nie może pobrać obrazów z ACR

Najczęściej przyczyna:
- brak `DOCKER_REGISTRY_SERVER_URL`
- brak `DOCKER_REGISTRY_SERVER_USERNAME`
- brak `DOCKER_REGISTRY_SERVER_PASSWORD`

Sprawdź też, czy nazwy obrazów są dokładnie takie jak w ćwiczeniu 2:
- `azure-app-backend`
- `azure-app-frontend`
- `azure-app-nginx`

---

### 2. Deploy przechodzi, ale aplikacja nie działa

Najczęściej przyczyna:
- brak `DATABASE_URL`
- brak `AZURE_STORAGE_CONNECTION_STRING`
- brak `AZURE_STORAGE_CONTAINER`

Backend używa tych zmiennych w app.py i app.py.

---

### 3. Workflow przechodzi, ale `/api/health` nie odpowiada

Sprawdź:
- czy `nginx` wystawia port `80:80`,
- czy w compose `nginx` zależy od `backend` i `frontend`,
- czy nie zmieniłeś nazw serwisów `backend` i `frontend`, bo są używane w nginx.conf.

---

## Jak to wpływa na ćwiczenie 4

Ta wersja ćwiczenia 3 nie blokuje ćwiczenia 4, ale ćwiczenie 4 trzeba zrobić trochę inaczej niż w obecnym materiale.

W obecnym materiale ćwiczenie 4 zakłada:
- logowanie GitHub Actions do Azure,
- pobieranie sekretów z Key Vault w workflow.

W Twojej sytuacji lepszy wariant to:

1. W App Service włącz `System assigned managed identity`.
2. Daj tej tożsamości dostęp do Key Vault.
3. W `Environment variables` w App Service podmień wartości:
   - `DATABASE_URL`
   - `AZURE_STORAGE_CONNECTION_STRING`
   - `AZURE_STORAGE_CONTAINER`

na referencje typu:

```text
@Microsoft.KeyVault(SecretUri=https://<twoj-kv>.vault.azure.net/secrets/DatabaseURL/<wersja>)
```

Dzięki temu:
- workflow z ćwiczenia 3 zostaje bez zmian,
- GitHub dalej deployuje tylko compose,
- sekrety nie są pobierane w GitHub Actions,
- aplikacja sama pobiera sekrety z Key Vault przez App Service.

To jest nawet lepsze praktycznie niż obecna wersja ćwiczenia 4.

---

## Najkrótsza wersja do wklejenia do materiału

Jeśli chcesz, możesz podmienić całe ćwiczenie 3 na ten skrót:

1. Utwórz Linux App Service typu `Docker Container`.
2. Pobierz `Publish Profile`.
3. Dodaj do GitHub Secrets:
   - `AZURE_WEBAPP_PUBLISH_PROFILE`
   - `AZURE_WEBAPP_NAME`
4. W App Service ustaw:
   - `DOCKER_REGISTRY_SERVER_URL`
   - `DOCKER_REGISTRY_SERVER_USERNAME`
   - `DOCKER_REGISTRY_SERVER_PASSWORD`
   - `DATABASE_URL`
   - `AZURE_STORAGE_CONNECTION_STRING`
   - `AZURE_STORAGE_CONTAINER`
5. Utwórz `docker-compose.appservice.yml`, który wskazuje obrazy z ACR z ćwiczenia 2.
6. Uruchom workflow z `azure/webapps-deploy@v3` i `configuration-file`.


## 4. ĆWICZENIE 3: Automatyczny deployment do Azure 

### 🎯 Cel: Automatyczne wdrożenie aplikacji na Azure App Service po każdym push

**0. Zanim zaczniesz wykonywać to ćwiczenie warto uzunąć istniejącą resource groupe lub uzywać nowej. W tym ćwiczeniu wszystkie kroki są do wykonania za pomocą CLI ale warto obserwować w portalu jak wszystko się zmienia. CLI jest wyborem. Wszystkie kroki mozna wykonać "klikając" w portalu.

**1. Utwórz zasoby bazowe w Azure**

1. Zaloguj się do Azure CLI:

> To polecenie otwiera przeglądarkę i loguje Ciebie do Azure. Bez tego Azure CLI nie będzie miał dostępu do Twoich zasobów na Azure.

~~~bash
az login
az account show -o table
~~~

2. Utwórz Resource Group (folder logiczny na Azure):

> Resource Group to pojemnik dla wszystkich zasobów (ACR, baza danych, App Service itp). Wszystkie zasoby w tym ćwiczeniu będą w tej grupie i będzie je łatwiej zarządzać/usuwać na koniec.

~~~bash
az group create -n technologie-chmurowe-rg -l polandcentral
~~~

3. Utwórz Azure Container Registry (prywatne repozytorium dla obrazów Docker):

> ACR (Azure Container Registry) to prywatne repozytorium do przechowywania obrazów Docker. GitHub Actions będzie budować obrazy i wysyłać je tutaj, potem App Service będzie je pobierać. Bez ACR nie moglibyśmy automatycznie budzować i deployować.
> - `--admin-enabled true` - włącza admin dostęp (login z username/password zamiast managed identity)
> - `--sku Basic` - najtańszy tier, wystarczy dla projektu

~~~bash
ACR_NAME=twojunikalnyacr123
az acr create -g technologie-chmurowe-rg -n $ACR_NAME --sku Basic --admin-enabled true
az acr show -g technologie-chmurowe-rg -n $ACR_NAME --query loginServer -o tsv
az acr credential show -n $ACR_NAME -o json
~~~

Zapisz:
- loginServer, np. twojunikalnyacr123.azurecr.io (adres repozytorium)
- username (login do ACR)
- passwords[0].value (hasło do ACR)

---

**2. Utwórz PostgreSQL (zarządzana baza danych w chmurze)**

> Backend aplikacji potrzebuje bazy danych do przechowywania danych. Zamiast instalować PostgreSQL lokalnie, używamy "managed" wersji na Azure - nie trzeba się martwić backupami, patching itp. Azure się tym zajmuje.

1. Utwórz serwer PostgreSQL:

> - `--public-access 0.0.0.0` - pozwala podłączyć się z dowolnego IP (dla ćwiczenia jest ok, w produkcji byśmy to ograniczyli)
> - `--sku-name Standard_B1ms` - malutka maszyna, wystarczy na projekt
> - `--version 16` - wersja PostgreSQL

~~~bash
PG_SERVER=tcpg$RANDOM
PG_ADMIN=pgadminuser
PG_PASS='MocneHaslo123!'

az postgres flexible-server create \
  -g technologie-chmurowe-rg \
  -n $PG_SERVER \
  -l polandcentral \
  --admin-user $PG_ADMIN \
  --admin-password "$PG_PASS" \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --version 16 \
  --storage-size 32 \
  --public-access 0.0.0.0
~~~

2. Utwórz bazę danych w serwere:

> Backend będzie klocować dane do bazy utworzonej w serwerie (nie globalnie w serwerie, ale w konkretnej bazie).

~~~bash
az postgres flexible-server db create \
  -g technologie-chmurowe-rg \
  -s $PG_SERVER \
  -d appdb
~~~

3. Zbuduj CONNECTION STRING (DATABASE_URL):

> To jest zmienną środowiskową którą Backend będzie czytać - zawiera wszystkie informacje do połączenia z bazą (host, port, username, password). Będziesz to wklejać do GitHub Secrets i App Service Settings.

~~~bash
DATABASE_URL="postgresql://${PG_ADMIN}:${PG_PASS}@${PG_SERVER}.postgres.database.azure.com:5432/appdb?sslmode=require"
echo $DATABASE_URL
~~~

Zapisz ten URL (będzie ci potrzebny w kilku miejscach).

---

**3. Utwórz Storage Account (magazyn na pliki/blob'i)**

> Backend będzie wrzucać uploaded pliki do cloud storage (zamiast dysku w kontenerze). Storage Account to miejsce na Azure gdzie przechowujemy takie pliki.

1. Utwórz Storage Account (konto magazynowe):

> - `--sku Standard_LRS` - standardowy tier, replikowany lokalnie (najtańszy)
> - `--kind StorageV2` - nowoczesna wersja Storage Account

~~~bash
STORAGE_NAME=tcstor$RANDOM
az storage account create \
  -g technologie-chmurowe-rg \
  -n $STORAGE_NAME \
  -l polandcentral \
  --sku Standard_LRS \
  --kind StorageV2
~~~

2. Pobierz connection string (credentials do Storage Account):

> Connection string zawiera wszystkie informacje do podłączenia się do Storage Account (jak DATABASE_URL ale dla plików). Backend będzie go czytać ze zmiennych środowiskowych.

~~~bash
AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
  -g technologie-chmurowe-rg \
  -n $STORAGE_NAME \
  --query connectionString -o tsv)

echo $AZURE_STORAGE_CONNECTION_STRING
~~~

3. Utwórz kontener (folder) wewnątrz Storage Account:

> Kontener to jak folder na dysku - będziemy tam складać uploaded pliki. Backend będzie pisać do kontenera "uploads".

~~~bash
CONTAINER_NAME=uploads
az storage container create \
  --name $CONTAINER_NAME \
  --connection-string "$AZURE_STORAGE_CONNECTION_STRING"
~~~

Zapisz:
- AZURE_STORAGE_CONNECTION_STRING (connection string do Storage Account)
- AZURE_STORAGE_CONTAINER=uploads (nazwa kontenera)

---

**4. Utwórz App Service (miejsca gdzie będzie działać konteneryzowana aplikacja)**

> App Service to PaaS (Platform as a Service) - Azure będzie zarządzać serwerami, OS, patching itp. Ty tylko deployujesz kontenery. To idealny sposób na uruchamianie Docker Compose na chmurze.

1. Utwórz App Service Plan (alokacja zasobów):

> Plan to "wielkość maszyny" - ile CPU, RAM, itp. B1 to najtańszy tier, wystarczy dla projektu.
> `--is-linux` - będziemy uruchamiać kontenery Linuxa (bo nasze Dockery są na Linux)

~~~bash
APP_PLAN=tc-app-plan
az appservice plan create \
  -g technologie-chmurowe-rg \
  -n $APP_PLAN \
  --is-linux \
  --sku B1
~~~

2. Utwórz Web App (aplikacja):

> To jest sama aplikacja na Azure. `-i` to initial image (na razie stawiamy domyślny obraz, potem go zamienimy na nasz)

~~~bash
WEBAPP_NAME=azure-app-cicd-666
az webapp create \
  -g technologie-chmurowe-rg \
  -p $APP_PLAN \
  -n $WEBAPP_NAME \
  -i mcr.microsoft.com/appsvc/staticsite:latest
~~~

---

**5. Skonfiguruj App Service (zmienne środowiskowe)**

> App Service musi wiedzieć:
> - Gdzie pobierać obrazy Docker (ACR + credentials)
> - Jak podłączyć się do bazy danych (DATABASE_URL)
> - Jak komunikować się ze Storage Account (AZURE_STORAGE_CONNECTION_STRING)
> Te zmienne będą dostępne dla kontenerów w zmiennych środowiskowych.

Pobranie credentials z ACR i ustawienie ich w App Service:

~~~bash
ACR_LOGIN_SERVER=$(az acr show -g technologie-chmurowe-rg -n "$ACR_NAME" --query 'loginServer' -o tsv)
ACR_USERNAME=$(az acr credential show -n "$ACR_NAME" --query 'username' -o tsv)
ACR_PASSWORD=$(az acr credential show -n "$ACR_NAME" --query 'passwords[0].value' -o tsv)

az webapp config appsettings set \
  -g technologie-chmurowe-rg \
  -n "$WEBAPP_NAME" \
  --settings \
  DOCKER_REGISTRY_SERVER_URL="https://$ACR_LOGIN_SERVER" \
  DOCKER_REGISTRY_SERVER_USERNAME="$ACR_USERNAME" \
  DOCKER_REGISTRY_SERVER_PASSWORD="$ACR_PASSWORD" \
  DATABASE_URL="$DATABASE_URL" \
  AZURE_STORAGE_CONNECTION_STRING="$AZURE_STORAGE_CONNECTION_STRING" \
  AZURE_STORAGE_CONTAINER="$CONTAINER_NAME"
~~~

---

**6. Utwórz Service Principal (tożsamość dla GitHub Actions)**

> Service Principal to jak "użytkownik" dla GitHub Actions. Azure mu zaufać i pozwoli mu deployować zasoby. Na tym poleceniu wyjdzie JSON z credentials - to jest bardzo wrażliwy plik (jak hasło root'a)!
> - `--role Contributor` - Service Principal będzie mieć uprawnienia do tworzenia/usuwania zasobów
> - `--scopes` - ograniczamy uprawnienia do naszej Resource Group (nie będzie móc ingerować w inne zasoby)
> - `--sdk-auth` - format JSON dla GitHub Actions

~~~bash
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

az ad sp create-for-rbac \
  --name "github-actions-sp-tc" \
  --role Contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/technologie-chmurowe-rg \
  --sdk-auth
~~~

Skopiuj **cały JSON** z outputu (będzie potrzebny w kroku 7).

---

**7. Dodaj sekrety do GitHub (aby workflow miał dostęp do Azure)**

> GitHub Actions będzie odczytywać te sekrety i używać ich do deployowania. Sekrety są szyfrowane - nie będą widoczne w logach ani nikomu.

GitHub → Settings → Secrets and variables → Actions → New repository secret

Dodaj sekrety:
1. **AZURE_CREDENTIALS** - cały JSON z kroku 6 (to pozwoli GitHub Actions logować się do Azure)
2. **AZURE_RG** - technologie-chmurowe-rg (nazwa resource group)
3. **AZURE_WEBAPP_NAME** - azure-app-cicd-666 (nazwa App Service)
4. **ACR_LOGIN_SERVER** - np. twojunikalnyacr123.azurecr.io (adres rejestru)
5. **ACR_USERNAME** - z outputu `az acr credential show` (login do ACR)
6. **ACR_PASSWORD** - z outputu `az acr credential show` (hasło do ACR)

---

**8. Utwórz Docker Compose dla App Service**

> To jest plik konfiguracyjny który mówi App Service jakie kontenery uruchomić. Zawiera:
> - Obrazy do pobrania z ACR
> - Zmienne środowiskowe dla każdego kontenera
> - Mapowanie portów
> - Zależności między usługami

W repo utwórz plik `docker-compose.appservice.yml`:

~~~yaml
version: '3.8'

services:
  backend:
    image: twojunikalnyacr123.azurecr.io/azure-app-backend:latest
    environment:
      DATABASE_URL: ${DATABASE_URL}
      AZURE_STORAGE_CONNECTION_STRING: ${AZURE_STORAGE_CONNECTION_STRING}
      AZURE_STORAGE_CONTAINER: ${AZURE_STORAGE_CONTAINER}

  frontend:
    image: twojunikalnyacr123.azurecr.io/azure-app-frontend:latest

  nginx:
    image: twojunikalnyacr123.azurecr.io/azure-app-nginx:latest
    ports:
      - "80:80"
    depends_on:
      - backend
      - frontend
~~~

**Ważne:** Podmień `twojunikalnyacr123` na nazwę swojego ACR!

---

**9. Utwórz GitHub Actions workflow - budowanie obrazów**

> Ten workflow będzie:
> 1. Pobierać kod z repo
> 2. Logować się do ACR
> 3. Budować 3 obrazy Docker (backend, frontend, nginx)
> 4. Publikować je do ACR
> Uruchomi się automatycznie po każdym push do main.

Utwórz plik `.github/workflows/docker-build.yml` (jeśli nie masz):

~~~yaml
name: Docker Build & Push

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login ACR
        uses: docker/login-action@v3
        with:
          registry: ${{ secrets.ACR_LOGIN_SERVER }}
          username: ${{ secrets.ACR_USERNAME }}
          password: ${{ secrets.ACR_PASSWORD }}

      - name: Build backend
        uses: docker/build-push-action@v6
        with:
          context: ./backend
          push: true
          tags: |
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:latest
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:${{ github.sha }}

      - name: Build frontend
        uses: docker/build-push-action@v6
        with:
          context: ./frontend
          push: true
          tags: |
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-frontend:latest
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-frontend:${{ github.sha }}

      - name: Build nginx
        uses: docker/build-push-action@v6
        with:
          context: ./nginx
          push: true
          tags: |
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-nginx:latest
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-nginx:${{ github.sha }}
~~~

---

**10. Utwórz GitHub Actions workflow - deployment na Azure**

> Ten workflow będzie:
> 1. Czekać aż workflow budowania (Docker Build & Push) się skończy
> 2. Logować się do Azure (przy pomocy Service Principal)
> 3. Wysyłać docker-compose.appservice.yml do App Service
> 4. Restartować App Service (żeby zaciągnęło nowe kontenery)
> Po pierwszym deploycie aplikacja powinna być dostępna pod https://azure-app-cicd-666.azurewebsites.net

Utwórz plik `.github/workflows/deploy.yml`:

~~~yaml
name: Deploy to Azure App Service

on:
  workflow_run:
    workflows: ["Docker Build & Push"]
    types: [completed]
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    if: ${{ github.event_name == 'workflow_dispatch' || github.event.workflow_run.conclusion == 'success' }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v2
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Configure multi-container compose
        uses: azure/CLI@v2
        with:
          inlineScript: |
            az webapp config container set \
              --resource-group ${{ secrets.AZURE_RG }} \
              --name ${{ secrets.AZURE_WEBAPP_NAME }} \
              --multicontainer-config-type compose \
              --multicontainer-config-file docker-compose.appservice.yml

      - name: Restart app
        uses: azure/CLI@v2
        with:
          inlineScript: |
            az webapp restart \
              --resource-group ${{ secrets.AZURE_RG }} \
              --name ${{ secrets.AZURE_WEBAPP_NAME }}
~~~


---

**11. Wrzuć wszystkie pliki na GitHub**

> To uruchomi automatycznie workflow CI → Docker Build & Push → Deploy to Azure.

~~~bash
git add docker-compose.appservice.yml .github/workflows/deploy.yml .github/workflows/docker-build.yml
git commit -m "CI/CD: build to ACR and deploy compose to App Service"
git push origin main
~~~

---

**12. Sprawdzenie czy wszystko działa**

> Po pushu GitHub Actions automatycznie:
> - Uruchomi testy backendu
> - Zbuduje obrazy Docker
> - Wrzuci obrazy do ACR
> - Deployuje aplikację na App Service

1. Obserwuj workflow w GitHub Actions (zakładka Actions w repozytorium):
   - CI testy
   - Docker Build & Push
   - Deploy to Azure App Service

2. Sprawdź czy aplikacja jest dostępna (poczekaj 2-3 minuty aż App Service zaciągnie i uruchomi kontenery):
~~~text
https://azure-app-cicd-666.azurewebsites.net
~~~

3. Sprawdź health endpoint backendu:
~~~text
https://azure-app-cicd-666.azurewebsites.net/api/health
~~~

> Powinno zwrócić: `{"status":"healthy"}`

---

## 5. ĆWICZENIE 4: Bezpieczeństwo - przeniesienie secretów do Key Vault (15 min)

### 🎯 Cel: Bezpieczne zarządzanie wdrażając application secrets do Azure Key Vault zamiast trzymać je w App Service Settings

### Dlaczego Key Vault?

**Problem z secrets w App Service Settings (co robiliśmy w ćwiczeniu 3):**
- ❌ Hardcoded wartości w Portal (DATABASE_URL, AZURE_STORAGE_CONNECTION_STRING itp)
- ❌ Trudno rotować - zmiana wymaga ręcznej edycji w Portal
- ❌ Brak audit log kto i kiedy zmienił secrety
- ❌ Ryzyko: jeśli ktoś ma dostęp do Portal, widzi wszystkie sekrety
- ❌ Brak centralizacji - każdy projekt ma swoje sekrety

**Zalety Azure Key Vault:**
- ✅ Centralne, zabezpieczone miejsce na wszystkie sekrety
- ✅ Pełny audit log - wiesz kto, kiedy i co pobrał
- ✅ Automatyczna rotacja kluczy
- ✅ Integracja z Managed Identity (App Service bezpiecznie pobiera sekrety bez hasła)
- ✅ Kontrola dostępu - App Service daje się dostęp tylko do konkretnych sekretów
- ✅ Zgodność z compliance (GDPR, ISO, PCI-DSS)

---

### Krok 1: Utwórz lub użyj istniejącego Key Vault

**WAŻNE:** Ten krok też nadaje Ci uprawnienia do Key Vault'a, żeby uniknąć błędu "Forbidden".

~~~bash
  KV_NAME=tc-kv-$RANDOM
  
  az keyvault create \
    -g technologie-chmurowe-rg \
    -n $KV_NAME \
    -l polandcentral \
    --default-action Allow
~~~

**Teraz daj sobie uprawnienia do Key Vault'a:**

> Jeśli pominiesz ten krok, będziesz mieć błąd "Forbidden" gdy będziesz próbował dodać sekrety.

~~~bash
# Pobierz swój Object ID
MY_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)

# Daj sobie rolę Key Vault Secrets Officer
az role assignment create \
  --role "Key Vault Secrets Officer" \
  --assignee "$MY_OBJECT_ID" \
  --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/technologie-chmurowe-rg/providers/Microsoft.KeyVault/vaults/$KV_NAME"
~~~

---

### Krok 2: Dodaj application secrets do Key Vault

> Z ćwiczenia 3 mamy 3 zmienne środowiskowe, które trzymaliśmy w App Service Settings. Teraz je przenosimy do Key Vault.

Najpierw **zweryfikuj zmienne**:

~~~bash
echo "DATABASE_URL: ${DATABASE_URL:0:50}..." # pokazuje tylko pierwszych 50 znaków
echo "AZURE_STORAGE_CONNECTION_STRING: ${AZURE_STORAGE_CONNECTION_STRING:0:50}..."
echo "CONTAINER_NAME: $CONTAINER_NAME"
~~~

Jeśli któraś jest pusta, ustaw je (z wartości z ćwiczenia 3):

~~~bash
# Przykład - dostosuj do swoich wartości!
DATABASE_URL="postgresql://pgadminuser:MocneHaslo123!@tcpg28693.postgres.database.azure.com:5432/appdb?sslmode=require"
AZURE_STORAGE_CONNECTION_STRING="DefaultEndpointsProtocol=https;AccountName=tcstor9798;AccountKey=..."
CONTAINER_NAME="uploads"
~~~

Teraz dodaj sekrety:

~~~bash
az keyvault secret set \
  --vault-name "$KV_NAME" \
  --name "DatabaseURL" \
  --value "$DATABASE_URL"

az keyvault secret set \
  --vault-name "$KV_NAME" \
  --name "AzureStorageConnectionString" \
  --value "$AZURE_STORAGE_CONNECTION_STRING"

az keyvault secret set \
  --vault-name "$KV_NAME" \
  --name "AzureStorageContainerName" \
  --value "$CONTAINER_NAME"
~~~


**Dodanie ręczne przez Portal:**
1. Azure Portal → Key Vault `mojekeyvault` (lub Twoja nazwa)
2. **"Secrets"** → **"+ Generate/Import"**
3. Dodaj 3 sekrety:
   - **Name:** DatabaseURL, **Value:** `postgresql://...`
   - **Name:** AzureStorageConnectionString, **Value:** `DefaultEndpoints...`
   - **Name:** AzureStorageContainerName, **Value:** `uploads`

**Weryfikacja w CLI:**
~~~bash
az keyvault secret list --vault-name $KV_NAME --query "[].name" -o table
~~~

Powinieneś zobaczyć 3 sekrety: DatabaseURL, AzureStorageConnectionString, AzureStorageContainerName

---

### Krok 3: Włącz Managed Identity w App Service

> Managed Identity to tożsamość App Service na Azure. Dzięki niej App Service będzie mieć uprawnienia do Key Vault bez konieczności trzymania haseł.

~~~bash
az webapp identity assign \
  --resource-group technologie-chmurowe-rg \
  --name "$WEBAPP_NAME"

# Pobierz Object ID tożsamości App Service
WEBAPP_IDENTITY_OBJECT_ID=$(az webapp identity show \
  --resource-group technologie-chmurowe-rg \
  --name "$WEBAPP_NAME" \
  --query principalId -o tsv)

echo "App Service Identity Object ID: $WEBAPP_IDENTITY_OBJECT_ID"
~~~

---

### Krok 4: Daj App Service dostęp do Key Vault

> App Service musi mieć uprawnienia do odczytania sekretów z Key Vault. Udzielimy mu uprawnień "Get" (czytanie) - nie będzie mógł tworzyć, usuwać czy zmieniać sekretów.

~~~bash
KV_ID=$(az keyvault show -n "$KV_NAME" -g technologie-chmurowe-rg --query id -o tsv)

az role assignment create \
  --assignee-object-id "$WEBAPP_IDENTITY_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Key Vault Secrets User" \
  --scope "$KV_ID"
~~~

**Weryfikacja w Portal:**
1. Key Vault → **"Access control (IAM)"**
2. Wybierz zakładkę "Role assignments"
3. Powiniwneś zobaczyć wiersz z nazwą aplikacji oraz "Managed identity" w kolumne "Type" oraz rolą Key Vault Secrets User

---

### Krok 5: Zaktualizuj App Service Settings aby pobierał sekrety z Key Vault

> Zamiast hardcodowanych wartości w App Service Settings, będziemy tam umieszczać referencje do Key Vault. Format to: `@Microsoft.KeyVault(SecretUri=...)`
> 
> App Service automatycznie rozwiąże te referencje i zlinuje zmienne środowiskowe do wartości z Key Vault.

Najpierw pobierz URI Key Vault:

~~~bash
KV_URI=$(az keyvault show --name $KV_NAME --query id -o tsv)
echo "Key Vault URI: $KV_URI"
~~~

Teraz zaktualizuj App Service Settings (zmiana 3 zmiennych aplikacyjnych):

~~~bash
az webapp config appsettings set \
  -g technologie-chmurowe-rg \
  -n "$WEBAPP_NAME" \
  --settings \
  DATABASE_URL="@Microsoft.KeyVault(VaultName=$KV_NAME;SecretName=DatabaseURL)" \
  AZURE_STORAGE_CONNECTION_STRING="@Microsoft.KeyVault(VaultName=$KV_NAME;SecretName=AzureStorageConnectionString)" \
  AZURE_STORAGE_CONTAINER="@Microsoft.KeyVault(VaultName=$KV_NAME;SecretName=AzureStorageContainerName)"
~~~

**Co się stało:**
- Zamiast wartości: `postgresql://user:pass@...`
- Teraz: `@Microsoft.KeyVault(VaultName=tc-kv-xxxxx;SecretName=DatabaseURL)`
- App Service będzie automatycznie czytać tę referencję i pobierać rzeczywistą wartość z Key Vault

**Weryfikacja w Portal:**
1. App Service → **"Settings"** → **"Environment variables"**
2. Sprawdź 3 zmienne (DATABASE_URL, AZURE_STORAGE_CONNECTION_STRING, AZURE_STORAGE_CONTAINER)
3. Wartości powinny być widoczne jako referencje Key Vault

---

### Krok 6: Restart App Service żeby zabrał nowe zmienne

~~~bash
az webapp restart \
  --resource-group technologie-chmurowe-rg \
  --name "$WEBAPP_NAME"
~~~

**Czekaj 2-3 minuty aż się App Service uruchomi z nowymi ustawieniami.**

---

### Krok 7: Weryfikacja że wszystko działa

1. **Sprawdź czy aplikacja działa:**
~~~text
https://azure-app-cicd-666.azurewebsites.net
~~~

2. **Sprawdź health endpoint:**
~~~text
https://azure-app-cicd-666.azurewebsites.net/api/health
~~~

> Powinno zwrócić: `{"status":"healthy"}`

---

### Krok 8: GitHub Actions workflow - bez zmian

> Ważne: Workflow z ćwiczenia 3 **zostaje dokładnie taki sam!**
> 
> Nie musimy nic zmieniać. GitHub Actions dalej deployuje docker-compose.appservice.yml, ustawienia w App Service pozostają bez zmian z punktu widzenia workflow.
> 
> Zmienia się tylko **gdzie** są przechowywane sekrety:
> - **Przed (Ćwiczenie 3):** App Service Settings z hardcodowanymi wartościami
> - **Teraz (Ćwiczenie 4):** Key Vault z referencjami w App Service Settings

Workflow dalej wygląda tak:

~~~yaml
# .github/workflows/deploy.yml (bez zmian!)
name: Deploy to Azure App Service

on:
  workflow_run:
    workflows: ["Docker Build & Push"]
    types: [completed]
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    if: ${{ github.event_name == 'workflow_dispatch' || github.event.workflow_run.conclusion == 'success' }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v2
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Configure multi-container compose
        uses: azure/CLI@v2
        with:
          inlineScript: |
            az webapp config container set \
              --resource-group ${{ secrets.AZURE_RG }} \
              --name ${{ secrets.AZURE_WEBAPP_NAME }} \
              --multicontainer-config-type compose \
              --multicontainer-config-file docker-compose.appservice.yml

      - name: Restart app
        uses: azure/CLI@v2
        with:
          inlineScript: |
            az webapp restart \
              --resource-group ${{ secrets.AZURE_RG }} \
              --name ${{ secrets.AZURE_WEBAPP_NAME }}
~~~

**Jak przetestować cały workflow od początku:**

1. Zmień dowolny drobny element w repozytorium, który nie zepsuje aplikacji, np. dopisz komentarz w `README.md` albo w pliku workflow.
2. Zrób commit i push do gałęzi `main`:

~~~bash
git add .
git commit -m "Test full workflow after Key Vault migration"
git push origin main
~~~

3. Wejdź do GitHub -> **Actions** i obserwuj cały łańcuch workflow:
   - `CI - Backend Tests`
   - `Docker Build & Push`
   - `Deploy to Azure App Service`
4. Sprawdź, czy wszystkie workflow zakończyły się na zielono.
5. Po zakończeniu deployu wejdź do Azure Portal -> App Service -> **Environment variables**.
6. Zweryfikuj, że:
   - `DATABASE_URL` jest referencją do Key Vault,
   - `AZURE_STORAGE_CONNECTION_STRING` jest referencją do Key Vault,
   - `AZURE_STORAGE_CONTAINER` jest referencją do Key Vault.
7. Otwórz aplikację i sprawdź endpoint health:

~~~text
https://azure-app-cicd-666.azurewebsites.net/api/health
~~~

Jeśli cały test przeszedł poprawnie, to znaczy że:
- testy CI nadal działają,
- obrazy Docker nadal budują się i publikują do ACR,
- workflow deploymentu nadal wdraża aplikację na App Service,
- App Service poprawnie rozwiązuje sekrety z Key Vault,
- Managed Identity ma poprawne uprawnienia do odczytu sekretów.

**Ćwiczenie:** wymuś ponowne przejście całego workflow po zmianie sekretu

1. Wejdź do Azure Portal -> Key Vault -> **Secrets**.
2. Otwórz sekret `AzureStorageContainerName`.
3. Utwórz nową wersję sekretu z inną wartością, np. `uploads-test`.
4. W repozytorium zrób małą zmianę techniczną, np. dopisz pustą linię w `README.md`.
5. Zrób commit i push do `main`, aby uruchomić cały workflow jeszcze raz.
6. Sprawdź w GitHub Actions, czy cały łańcuch przeszedł poprawnie.
7. Po deployu sprawdź, czy aplikacja nadal działa.
8. Przywróć poprzednią poprawną wartość sekretu i ponownie wykonaj commit + push.

To ćwiczenie pokazuje praktycznie, że po migracji do Key Vault nadal testujesz cały pipeline od początku do końca, a aplikacja korzysta z sekretów przechowywanych poza App Service.
