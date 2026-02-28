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


## 4. ĆWICZENIE 3: Automatyczny deployment do Azure (25 min)

### 🎯 Cel: Automatyczne wdrożenie aplikacji na Azure App Service po każdym push

### Wariant A: Deploy do Azure Container Instances (ACI) - Najłatwiejszy

**Krok 1: Konfiguracja Azure Service Principal**

Service Principal to tożsamość dla aplikacji - pozwala GitHub Actions zarządzać zasobami Azure.

**1.1. Utwórz Service Principal:**
```bash
# Pobierz subscription ID
az account show --query id -o tsv

# Utwórz Service Principal z uprawnieniami Contributor
az ad sp create-for-rbac \
  --name "github-actions-sp" \
  --role Contributor \
  --scopes /subscriptions/<TWOJE_SUBSCRIPTION_ID>/resourceGroups/technologie-chmurowe-rg \
  --sdk-auth

# ZAPISZ cały output JSON! Będzie wyglądał tak:
{
  "clientId": "xxxxx",
  "clientSecret": "xxxxx",
  "subscriptionId": "xxxxx",
  "tenantId": "xxxxx",
  ...
}
```

**1.2. Dodaj jako secret w GitHub:**
- GitHub repo → **"Settings"** → **"Secrets and variables"** → **"Actions"**
- **"New repository secret"**
- **Name:** `AZURE_CREDENTIALS`
- **Value:** **Cały JSON** z poprzedniego kroku
- **"Add secret"**

---

**Krok 2: Dodaj dodatkowe secrety**

Będą nam potrzebne do deploy:

**Secret 1:**
- **Name:** `AZURE_RG`
- **Value:** `technologie-chmurowe-rg`

**Secret 2:** (jeśli jeszcze nie masz)
- **Name:** `DATABASE_URL`
- **Value:** `postgresql://user:password@host:5432/dbname` (Twój connection string)

**Secret 3:**
- **Name:** `AZURE_STORAGE_CONNECTION_STRING`
- **Value:** `DefaultEndpointsProtocol=https;AccountName=...` (z Azure Storage)

**Secret 4:**
- **Name:** `AZURE_STORAGE_CONTAINER`
- **Value:** `demo-container` (lub nazwa Twojego kontenera)

---

**Krok 3: Workflow deployment**

**3.1. Utwórz plik `.github/workflows/deploy.yml`:**

```yaml
name: Deploy to Azure

on:
  workflow_run:
    workflows: ["Docker Build & Push"]
    types:
      - completed
    branches: [main]
  workflow_dispatch:  # Manual trigger

jobs:
  deploy:
    name: Deploy to Azure Container Instances
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Deploy Backend Container
        uses: azure/aci-deploy@v1
        with:
          resource-group: ${{ secrets.AZURE_RG }}
          dns-name-label: azure-app-backend-${{ github.run_number }}
          image: ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:latest
          registry-login-server: ${{ secrets.ACR_LOGIN_SERVER }}
          registry-username: ${{ secrets.ACR_USERNAME }}
          registry-password: ${{ secrets.ACR_PASSWORD }}
          name: azure-app-backend
          location: polandcentral
          cpu: 1
          memory: 1.5
          ports: 5000
          environment-variables: |
            DATABASE_URL=${{ secrets.DATABASE_URL }}
            AZURE_STORAGE_CONNECTION_STRING=${{ secrets.AZURE_STORAGE_CONNECTION_STRING }}
            AZURE_STORAGE_CONTAINER=${{ secrets.AZURE_STORAGE_CONTAINER }}
      
      - name: Deploy Frontend Container
        uses: azure/aci-deploy@v1
        with:
          resource-group: ${{ secrets.AZURE_RG }}
          dns-name-label: azure-app-frontend-${{ github.run_number }}
          image: ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-frontend:latest
          registry-login-server: ${{ secrets.ACR_LOGIN_SERVER }}
          registry-username: ${{ secrets.ACR_USERNAME }}
          registry-password: ${{ secrets.ACR_PASSWORD }}
          name: azure-app-frontend
          location: polandcentral
          cpu: 0.5
          memory: 0.5
          ports: 8080
      
      - name: Get Frontend URL
        run: |
          FRONTEND_URL=$(az container show \
            --resource-group ${{ secrets.AZURE_RG }} \
            --name azure-app-frontend \
            --query ipAddress.fqdn \
            --output tsv)
          
          echo "🚀 Application deployed!"
          echo "Frontend URL: http://${FRONTEND_URL}:8080"
      
      - name: Deployment Summary
        run: |
          echo "✅ Deployment completed successfully!"
          echo "Check Azure Portal for full details."
```

**3.2. Commit i push:**
```bash
git add .github/workflows/deploy.yml
git commit -m "Add deployment workflow to Azure"
git push origin main
```

---

**Krok 4: Testowanie deployment**

**4.1. Obserwuj workflow:**
- GitHub → **"Actions"**
- Powinny uruchomić się **3 workflow**:
  1. ✅ "CI - Backend Tests"
  2. ✅ "Docker Build & Push" (po testach)
  3. ✅ "Deploy to Azure" (po build)

**4.2. Sprawdź Azure:**
```bash
# Lista Container Instances
az container list \
  --resource-group technologie-chmurowe-rg \
  --output table

# Pobierz URL frontenda
az container show \
  --resource-group technologie-chmurowe-rg \
  --name azure-app-frontend \
  --query ipAddress.fqdn \
  --output tsv
```

**4.3. Zobacz swoją aplikację:**
- Skopiuj URL z poprzedniego kroku
- Otwórz w przeglądarce: `http://<URL>:8080`
- Przetestuj dodawanie użytkowników i upload PDF

---

### Wariant B: Deploy do Azure App Service (Web App) - Bardziej produkcyjny

**Różnice względem ACI:**
- ✅ Lepsze zarządzanie wieloma kontenerami (docker-compose)
- ✅ Bardziej stabilny dla aplikacji produkcyjnych
- ✅ Łatwiejsze skalowanie
- ❌ Bardziej skomplikowana konfiguracja

**Krok 1: Przygotuj docker-compose dla Azure:**

Utwórz plik `docker-compose.azure.ci.yml`:
```yaml
version: '3.8'

services:
  backend:
    image: ${ACR_LOGIN_SERVER}/azure-app-backend:latest
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - AZURE_STORAGE_CONNECTION_STRING=${AZURE_STORAGE_CONNECTION_STRING}
      - AZURE_STORAGE_CONTAINER=${AZURE_STORAGE_CONTAINER}
    ports:
      - "5000:5000"

  frontend:
    image: ${ACR_LOGIN_SERVER}/azure-app-frontend:latest
    ports:
      - "8080:8080"

  nginx:
    image: ${ACR_LOGIN_SERVER}/azure-app-nginx:latest
    ports:
      - "80:80"
    depends_on:
      - backend
      - frontend
```

**Krok 2: Zmodyfikuj workflow `.github/workflows/deploy.yml`:**

```yaml
name: Deploy to Azure App Service

on:
  workflow_run:
    workflows: ["Docker Build & Push"]
    types:
      - completed
    branches: [main]

jobs:
  deploy:
    name: Deploy to Azure Web App
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Deploy to Azure Web App
        uses: azure/webapps-deploy@v2
        with:
          app-name: azure-app-cicd  # Nazwa Twojej Web App
          images: |
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-nginx:latest
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:latest
            ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-frontend:latest
      
      - name: Application URL
        run: |
          echo "🚀 Application deployed!"
          echo "URL: https://azure-app-cicd.azurewebsites.net"
```

---

### 💡 Która opcja wybrać?

| Cecha | Azure Container Instances (ACI) | Azure App Service |
|-------|----------------------------------|-------------------|
| **Łatwość** | ⭐⭐⭐⭐⭐ Bardzo łatwe | ⭐⭐⭐ Średnia |
| **Koszty** | ~$30-40/miesiąc (płacisz za czas) | Free tier F1/B1 (750h) |
| **Multi-container** | ⭐⭐ Osobne kontenery | ⭐⭐⭐⭐⭐ Docker Compose |
| **Dla projektu** | ✅ Wystarczy | ✅✅ Lepsze |

**Rekomendacja:** Zacznij od **ACI** (prostsze), potem przenieś na **App Service** gdy opanujesz podstawy.

---

## 5. ĆWICZENIE 4: Bezpieczeństwo i Azure Key Vault (15 min)

### 🎯 Cel: Bezpieczne zarządzanie secretami używając Azure Key Vault

### Dlaczego Key Vault?

**Problem z secrets w GitHub:**
- ❌ Są widoczne dla maintainerów repo
- ❌ Trudno rotować (zmiana wymaga update w GitHub)
- ❌ Każdy projekt ma swoje secrets (duplikacja)
- ❌ Nie ma audit log kto i kiedy używał

**Zalety Azure Key Vault:**
- ✅ Centralne miejsce na wszystkie secrets
- ✅ Pełny audit log (kto, kiedy, co pobrał)
- ✅ Automatyczna rotacja kluczy
- ✅ Integracja z Managed Identity (nie trzeba haseł!)
- ✅ Zgodność z compliance (GDPR, ISO)

---

### Krok 1: Utworzenie Key Vault

**Przez Azure CLI:**
```bash
# Utwórz Key Vault (nazwa globalnie unikalna)
az keyvault create \
  --name <twoja-nazwa-kv> \
  --resource-group technologie-chmurowe-rg \
  --location polandcentral \
  --enable-rbac-authorization false

# Dodaj secrety
az keyvault secret set \
  --vault-name <twoja-nazwa-kv> \
  --name "DatabaseURL" \
  --value "postgresql://user:password@host:5432/dbname"

az keyvault secret set \
  --vault-name <twoja-nazwa-kv> \
  --name "AzureStorageConnectionString" \
  --value "DefaultEndpointsProtocol=https;AccountName=..."

az keyvault secret set \
  --vault-name <twoja-nazwa-kv> \
  --name "AzureStorageContainer" \
  --value "demo-container"
```

**Przez Portal:**
1. Azure Portal → wyszukaj **"Key vaults"**
2. **"+ Create"**
3. Wypełnij:
   - **Resource group:** `technologie-chmurowe-rg`
   - **Key vault name:** `<twoja-nazwa-kv>`
   - **Region:** Poland Central
   - **Pricing tier:** Standard
4. **"Review + Create"** → **"Create"**
5. Po utworzeniu → **"Secrets"** → **"+ Generate/Import"**
6. Dodaj 3 secrety:
   - Name: `DatabaseURL`, Value: `postgresql://...`
   - Name: `AzureStorageConnectionString`, Value: `Default...`
   - Name: `AzureStorageContainer`, Value: `demo-container`

---

### Krok 2: Nadanie uprawnień Service Principal

**Service Principal musi mieć dostęp do Key Vault:**
```bash
# Pobierz Object ID swojego Service Principal
az ad sp list --display-name "github-actions-sp" --query "[0].id" -o tsv

# Nadaj uprawnienia do sekretów
az keyvault set-policy \
  --name <twoja-nazwa-kv> \
  --object-id <OBJECT_ID_Z_POPRZEDNIEGO_KROKU> \
  --secret-permissions get list
```

**Przez Portal:**
1. Key Vault → **"Access policies"**
2. **"+ Add Access Policy"**
3. **Secret permissions:** Get, List
4. **Select principal:** wyszukaj `github-actions-sp`
5. **Add** → **Save**

---

### Krok 3: Modyfikacja workflow do używania Key Vault

**3.1. Dodaj secret z nazwą Key Vault do GitHub:**
- GitHub → **"Settings"** → **"Secrets"** → **"New repository secret"**
- **Name:** `KEY_VAULT_NAME`
- **Value:** `<twoja-nazwa-kv>`

**3.2. Zmodyfikuj `.github/workflows/deploy.yml`:**

```yaml
name: Deploy to Azure (with Key Vault)

on:
  workflow_run:
    workflows: ["Docker Build & Push"]
    types:
      - completed
    branches: [main]
  workflow_dispatch:

jobs:
  deploy:
    name: Deploy to Azure Container Instances
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      # NOWY KROK: Pobierz secrety z Key Vault
      - name: Get secrets from Key Vault
        uses: Azure/get-keyvault-secrets@v1
        with:
          keyvault: ${{ secrets.KEY_VAULT_NAME }}
          secrets: 'DatabaseURL, AzureStorageConnectionString, AzureStorageContainer'
        id: keyvault
      
      - name: Deploy Backend Container
        uses: azure/aci-deploy@v1
        with:
          resource-group: ${{ secrets.AZURE_RG }}
          dns-name-label: azure-app-backend-${{ github.run_number }}
          image: ${{ secrets.ACR_LOGIN_SERVER }}/azure-app-backend:latest
          registry-login-server: ${{ secrets.ACR_LOGIN_SERVER }}
          registry-username: ${{ secrets.ACR_USERNAME }}
          registry-password: ${{ secrets.ACR_PASSWORD }}
          name: azure-app-backend
          location: polandcentral
          cpu: 1
          memory: 1.5
          ports: 5000
          # ZMIANA: Użyj secrets z Key Vault zamiast GitHub Secrets
          environment-variables: |
            DATABASE_URL=${{ steps.keyvault.outputs.DatabaseURL }}
            AZURE_STORAGE_CONNECTION_STRING=${{ steps.keyvault.outputs.AzureStorageConnectionString }}
            AZURE_STORAGE_CONTAINER=${{ steps.keyvault.outputs.AzureStorageContainer }}
      
      # ... reszta kroków bez zmian
```

**3.3. Commit i push:**
```bash
git add .github/workflows/deploy.yml
git commit -m "Use Azure Key Vault for secrets"
git push origin main
```

---

### Krok 4: Weryfikacja security

**4.1. Sprawdź audit log w Key Vault:**
```bash
# Zobacz kto pobierał secrety (ostatnie 24h)
az monitor activity-log list \
  --resource-group technologie-chmurowe-rg \
  --offset 24h \
  --query "[?contains(resourceId, 'keyvault')]" \
  --output table
```

**Przez Portal:**
- Key Vault → **"Monitoring"** → **"Logs"**
- Wybierz zapytanie: **"Show Key Vault operations"**
- Zobacz kto i kiedy pobierał secrety

---

### 💡 Best Practices dla Secrets:

**✅ DO:**
- Używaj Key Vault dla produkcji
- Rotuj secrety regularnie (np. co 90 dni)
- Używaj Managed Identity gdzie możliwe
- Monitoruj dostęp (włącz logging)
- Minimal permissions (tylko Get, nie List wszystkiego)

**❌ DON'T:**
- Nigdy nie commituj secrets do Git
- Nie loguj secrets w workflow (`echo $SECRET` ❌)
- Nie udostępniaj tych samych credentials wszędzie
- Nie używaj `admin` credentials w produkcji

---

## 6. Zaawansowane aspekty CI/CD (10 min)

### Multi-Stage Deployment (Środowiska)

**Scenariusz:** Wdrażaj najpierw na staging, testuj, potem na produkcję.

**Przykład workflow z approval:**
```yaml
name: Multi-Stage Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    environment: staging
    
    steps:
      - name: Deploy to staging
        run: |
          echo "Deploying to staging..."
          # ... deployment steps
      
      - name: Run E2E tests on staging
        run: |
          echo "Running E2E tests..."
          # npm run test:e2e --baseUrl=https://staging.app
  
  deploy-production:
    name: Deploy to Production
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: 
      name: production
      url: https://app.azurewebsites.net
    
    steps:
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # ... deployment steps
```

**Konfiguracja approval w GitHub:**
1. Repo → **"Settings"** → **"Environments"**
2. **"New environment"** → Nazwa: `production`
3. Zaznacz **"Required reviewers"**
4. Dodaj siebie jako reviewera
5. **"Save protection rules"**

**Efekt:**
- Push do `main` → auto-deploy na staging
- Testy E2E na staging ✅
- Czeka na Twoje approval (email notification)
- Klikniesz "Approve" → deploy na produkcję

---

### Monitoring i Notyfikacje

**Status badge w README:**
```markdown
![CI Status](https://github.com/USER/REPO/workflows/CI%20-%20Backend%20Tests/badge.svg)
![Deploy Status](https://github.com/USER/REPO/workflows/Deploy%20to%20Azure/badge.svg)
```

**Notyfikacja na Slack/Discord przy błędzie:**
```yaml
- name: Notify on failure
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "❌ Deployment failed! Check: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
      }
```

**Email notification (wbudowane w GitHub):**
- Settings → Notifications → Actions
- Zaznacz "Send notifications for failed workflows only"

---

### Optymalizacje Performance

**1. Caching dependencies:**
```yaml
- name: Cache pip packages
  uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

**2. Matrix strategy (testy na wielu wersjach):**
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.9, 3.10, 3.11]
    
    steps:
      - uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}
      - run: pytest
```

**3. Fail fast:**
```yaml
strategy:
  fail-fast: true  # Przerwij wszystkie joby jeśli jeden failuje
  matrix:
    ...
```

**4. Conditional steps:**
```yaml
- name: Deploy only on main branch
  if: github.ref == 'refs/heads/main'
  run: ./deploy.sh
```

---

### Best Practices - Checklist

**✅ Struktura workflow:**
- [ ] Workflow ma jasną nazwę (`name: CI - Backend Tests`)
- [ ] Używa `on: push` dla CI, `on: workflow_run` dla CD
- [ ] Joby mają sensowne nazwy i dependencies
- [ ] Każdy step ma opis (`name: Install dependencies`)

**✅ Secrets i bezpieczeństwo:**
- [ ] Wszystkie credentials w Secrets (nie w kodzie!)
- [ ] Service Principal z minimalnymi uprawnieniami
- [ ] Key Vault dla wrażliwych danych
- [ ] Secrets nie są logowane (`echo $SECRET` ❌)

**✅ Testy:**
- [ ] Testy jednostkowe przy każdym commit
- [ ] Testy E2E przed deployem na produkcję
- [ ] Coverage raport (>80% pokrycia)
- [ ] Fail fast - jeden błąd przerywa pipeline

**✅ Docker:**
- [ ] Build cache dla szybszych buildów
- [ ] Multi-stage builds (dev/prod)
- [ ] Obrazy tagowane commit SHA (wersjonowanie)
- [ ] Scan vulnerabilities (`docker scan` lub Trivy)

**✅ Deployment:**
- [ ] Health check po deployment
- [ ] Rollback strategy (poprzedni tag)
- [ ] Blue-green lub canary dla produkcji
- [ ] Monitoring i alerty

**✅ Dokumentacja:**
- [ ] README z badge'ami statusu
- [ ] Instrukcja jak uruchomić lokalnie
- [ ] Opis workflow w komentarzach YAML
- [ ] Changelog z wersjonowaniem

---

## 7. Podsumowanie i wskazówki do projektu końcowego (5 min)

### Czego się nauczyliśmy?

✅ **CI/CD fundamentals** - czym jest i dlaczego jest ważne
✅ **GitHub Actions** - tworzenie workflow, joby, steps
✅ **Automatyczne testy** - backend tests przy każdym commit
✅ **Docker w CI/CD** - build, push do ACR, deployment
✅ **Azure integration** - Container Registry, Key Vault, deployment
✅ **Secrets management** - bezpieczne przechowywanie credentials

---

### Wymagania projektu końcowego - CI/CD

**Minimalny workflow dla projektu:**

```
┌─────────────────────────────────────────────┐
│  1. Git push → GitHub                       │
└──────────────────┬──────────────────────────┘
                   │
         ┌─────────▼──────────┐
         │  CI: Run Tests     │
         │  - Unit tests      │
         │  - Linting         │
         └─────────┬──────────┘
                   │ ✅ Tests pass
         ┌─────────▼──────────┐
         │  Build Docker       │
         │  - Backend image    │
         │  - Frontend image   │
         └─────────┬──────────┘
                   │
         ┌─────────▼──────────┐
         │  Push to ACR        │
         └─────────┬──────────┘
                   │
         ┌─────────▼──────────┐
         │  Deploy to Azure    │
         │  - App Service/ACI  │
         │  - Update containers│
         └─────────┬──────────┘
                   │
         ┌─────────▼──────────┐
         │  Health Check       │  ← WAŻNE!
         │  curl /api/health   │
         └─────────────────────┘
```

---

### Punkty za CI/CD w projekcie:

**Podstawa (wymagane minimum):**
- ✅ Workflow CI z testami jednostkowymi
- ✅ Workflow CD z deployment do Azure
- ✅ Secrets w GitHub (lub Key Vault)
- ✅ README z instrukcją i badge'ami

**Dodatkowe punkty:**
- 🌟 Testy E2E (Playwright/Cypress)
- 🌟 Multi-stage deployment (staging → production)
- 🌟 Azure Key Vault dla secrets
- 🌟 Health check po deployment
- 🌟 Rollback mechanism
- 🌟 Monitoring i alerty
- 🌟 Code coverage reports

---

### Typowe problemy i rozwiązania

**Problem 1: "Secrets not found"**
```
Error: Secret DATABASE_URL not found
```
**Rozwiązanie:**
- Sprawdź czy secret jest dodany w GitHub: Settings → Secrets
- Nazwa musi być dokładnie taka sama (case-sensitive!)
- Sprawdź składnię: `${{ secrets.DATABASE_URL }}` (nie `$DATABASE_URL`)

---

**Problem 2: "Docker build fails w Actions, lokalnie działa"**
```
Error: failed to solve: failed to compute cache key
```
**Rozwiązanie:**
- Dodaj `.dockerignore` (wykluczpnode_modules, .git, .env)
- Sprawdź ścieżki w `docker build -f ./backend/Dockerfile`
- Użyj `context: ./backend` w build-push-action

---

**Problem 3: "Azure deployment timeout"**
```
Error: Deployment exceeded timeout of 20 minutes
```
**Rozwiązanie:**
- Zwiększ timeout: `timeout-minutes: 30`
- Sprawdź czy ACR ma włączony admin access
- Sprawdź czy Service Principal ma uprawnienia na Resource Group
- Użyj `--debug` flag w `az` commands

---

**Problem 4: "Tests pass lokalnie, fail w CI"**
```
ImportError: No module named 'app'
```
**Rozwiązanie:**
- Sprawdź czy `requirements.txt` zawiera wszystkie dependencies
- Dodaj `pip install -r requirements.txt` przed testami
- Sprawdź Python version (lokalnie 3.11, w CI 3.9?)
- Użyj `PYTHONPATH` jeśli potrzeba

---

**Problem 5: "Container crashes po deployment"**
```
Container 'backend' is in Waiting state
```
**Rozwiązanie:**
- Sprawdź logs: `az container logs --name backend --resource-group rg`
- Sprawdź czy env variables są przekazane
- Sprawdź connection string do bazy (firewall rules!)
- Health check endpoint: dodaj `/health` route

---

### Materiały dodatkowe

**Dokumentacja:**
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/)
- [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/)

**Przykładowe repozytoria:**
- [Awesome CI/CD Examples](https://github.com/topics/cicd)
- [GitHub Actions Examples](https://github.com/actions/starter-workflows)

**Narzędzia:**
- [act](https://github.com/nektos/act) - testowanie Actions lokalnie
- [actionlint](https://github.com/rhysd/actionlint) - linting workflow YAML

---

### Zadanie domowe (opcjonalnie)

Rozszerz swój pipeline o:

1. **Testy E2E:**
   - Dodaj Playwright lub Cypress
   - Uruchom testy na staging environment
   - Blokuj deploy na prod jeśli testy faila

2. **Code Quality:**
   - Dodaj linter (pylint, flake8, eslint)
   - Code coverage minimum 80%
   - SonarCloud integration

3. **Security scanning:**
   - Dodaj `trivy` do skanowania obrazów Docker
   - Sprawdzanie CVE w dependencies
   - OWASP ZAP dla security testing

4. **Monitoring:**
   - Azure Application Insights
   - Prometheus + Grafana
   - Alerty przy wysokim error rate

---

## Podsumowanie struktury plików projektu

Po zakończeniu zajęć, Twój projekt powinien wyglądać tak:

```
azure-app-cicd/
├── .github/
│   └── workflows/
│       ├── ci.yml                  # Testy backend
│       ├── docker-build.yml        # Build i push do ACR
│       └── deploy.yml              # Deployment do Azure
├── backend/
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── tests/
│       ├── __init__.py
│       └── test_api.py             # Testy jednostkowe
├── frontend/
│   ├── index.html
│   └── Dockerfile
├── nginx/
│   ├── nginx.conf
│   └── Dockerfile
├── docker-compose.yml              # Lokalny development
├── docker-compose.azure.ci.yml     # Azure deployment
├── .env.example                    # Przykładowe env variables
├── .gitignore
└── README.md                       # Z badge'ami CI/CD
```

---

## Pytania i odpowiedzi

**Q: Czy muszę używać Azure? Mogę AWS/GCP?**
A: Możesz, ale Azure ma darmowe tiery dla studentów i lepszą integrację z GitHub Actions. Rekomendujemy Azure dla tego projektu.

**Q: Ile kosztuje uruchomienie CI/CD?**
A: GitHub Actions: 2000 minut/miesiąc darmowe (publiczne repo unlimited). Azure: Free tier wystarczy dla projektu. Łącznie ~0 PLN dla projektu studenckiego.

**Q: Co jeśli przekroczę limit minut Actions?**
A: Dla publicznych repo nie ma limitu. Dla prywatnych: optymalizuj workflow (cache, fail-fast) lub uzyj self-hosted runners.

**Q: Czy muszę mieć testy aby mieć CI/CD?**
A: Technicznie nie, ale to traci sens CI. Minimum: prosty test czy aplikacja się uruchamia.

**Q: Jak często powinienem deployować?**
A: W projekcie: przy każdym merge do `main`. W prawdziwym świecie: zależy, ale częste małe deploye > rzadkie duże.

**Q: Co jeśli zapomnę zatrzymać zasoby Azure?**
A: Ustaw budżet alert w Azure! W najgorszym przypadku kontakt z support dla studentów.

---

## Gratulacje! 🎉

Ukończyłeś zajęcia z CI/CD. Teraz potrafisz:
- ✅ Tworzyć pipeline CI/CD w GitHub Actions
- ✅ Automatyzować testy i deployment
- ✅ Integrować Docker z Azure
- ✅ Bezpiecznie zarządzać secretami

**Następne kroki:**
1. Zastosuj CI/CD w swoim projekcie końcowym
2. Eksperymentuj z różnymi strategiami deployment
3. Dodaj monitoring i alerty
4. Pokaż to w portfolio! 💼

**Powodzenia z projektem!** 🚀
