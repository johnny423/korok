requirements
poetry and docker + docker compose

install poetry
```bash
pip install poetry==1.8.2
```

step the project
```bash
poetry install
pre-commit install
```

build image
```bash
docker image build . --file korok/Dockerfile -t korok:latest
```

Running docker compose
```bash
docker compose up -d
docker compose down
```
