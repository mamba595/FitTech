# FitTech - REST API for Fitness and Nutrition

FitTech is a personal learning project: a FastAPI REST API for a fitness and nutrition app, built to practice the full path from backend code to containers, tests, CI/CD and AWS infrastructure as code.

This repository should be read as a portfolio/demo project, not as a production service with real users or uptime guarantees.

## What this project demonstrates

- Backend API design with FastAPI, Pydantic schemas and SQLAlchemy models.
- Authentication using password hashing and JWT bearer tokens.
- PostgreSQL persistence with local Docker Compose support.
- Unit and integration tests with pytest.
- CI/CD with GitHub Actions, dependency checks, Docker image build/push and vulnerability scanning.
- Terraform infrastructure for an AWS ECS Fargate deployment with VPC, ALB, ECR, RDS and security groups.

## Architecture

The application exposes REST endpoints for:

- User registration and login.
- User onboarding data.
- Food logs.
- Workout logs.
- A dashboard with BMR, TDEE, macro targets and daily activity/food summaries.
- Health checks.

Local architecture:

```text
Client -> FastAPI container -> PostgreSQL container
```

Cloud architecture implemented in Terraform:

```text
Internet -> ALB -> ECS Fargate tasks -> RDS PostgreSQL
                    |
                    v
                  ECR image
```

The AWS architecture is documented in `infra/README.md` and illustrated in `docs/images/`.

## Repository structure

```text
app/                  FastAPI application code
app/api/v1/endpoints  REST endpoint modules
app/models            SQLAlchemy models
app/schemas           Pydantic schemas
app/services          Business calculations
tests/unit            Unit tests for calculation logic
tests/integration     HTTP integration tests against the API
infra/                Terraform infrastructure code
.github/workflows     CI/CD pipeline
```

## Local setup

Create a local environment file:

```bash
cp .env.example .env
```

Start the API and database:

```bash
docker-compose up --build
```

Stop the local environment:

```bash
docker-compose down
```

The API listens on:

```text
http://localhost:8000
```

Health check:

```bash
curl http://localhost:8000/health
```

## Tests

Install dependencies in a Python environment:

```bash
pip install -r requirements.txt
```

Run unit tests:

```bash
pytest tests/unit
```

Integration tests expect the API to be running and use `API_BASE_URL`, defaulting to `http://localhost:8000`:

```bash
pytest tests/integration
```

## CI/CD

The GitHub Actions workflow in `.github/workflows/ci-cd.yml` includes:

- Python dependency installation.
- Lint checks with flake8.
- Dependency security checks with safety.
- Unit tests with pytest.
- Docker build and push to AWS ECR.
- Trivy image vulnerability scan.
- Integration tests against PostgreSQL.
- Terraform plan/apply for AWS infrastructure.
- Health check after deployment.
- Terraform destroy cleanup.

If you review this repository for recruiting, treat the pipeline as implemented automation. Confirm actual successful workflow runs before claiming stable production deployment.

## Terraform and AWS

The Terraform code under `infra/` models:

- VPC with public and private subnets.
- Internet gateway and NAT gateways.
- Application Load Balancer.
- ECS Fargate service and task definition.
- RDS PostgreSQL instance.
- IAM roles and security groups.

Manual Terraform commands are documented in `infra/README.md`. Do not commit local Terraform state, plans or secrets.

## API endpoints

- `POST /auth/register`
- `POST /auth/token`
- `POST /users/{user_id}/onboarding`
- `GET /users/{user_id}/onboarding`
- `PUT /users/{user_id}/onboarding`
- `POST /users/{user_id}/food-logs`
- `GET /users/{user_id}/food-logs`
- `POST /users/{user_id}/workout-logs`
- `GET /users/{user_id}/workout-logs`
- `GET /dashboard`
- `GET /health`

## Current status and limitations

- Personal portfolio project, not a production system.
- No real users, SLA, monitoring or long-running deployment evidence is included in this repository.
- Secrets must be provided through local `.env` files or GitHub/AWS secrets.
- The local Docker Compose password is a development placeholder.
- Terraform state files must not be committed.
