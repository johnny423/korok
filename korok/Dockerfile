# Pull official latest Python Docker image (Pulished with version 3.11.0)
FROM python:3.11-buster as builder

# Set the working directory
WORKDIR /app

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

RUN pip install poetry==1.4.2

# Copy all files todo: better?
COPY pyproject.toml poetry.lock ./

RUN poetry install --without dev --no-root && rm -rf $POETRY_CACHE_DIR

# The runtime image, used to just run the code provided its virtual environment
FROM python:3.11-slim-buster as runtime

#RUN apt-get update && apt-get install -y netcat-traditional

# Set the server port
EXPOSE 8000

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
COPY ./korok /app/korok

#RUN chmod +x /app/korok/entrypoint.sh
#
## Execute entrypoint.sh
#ENTRYPOINT ["/app/korok/entrypoint.sh" ]

# Start up the backend server
CMD uvicorn kork.src.main:backend_app --reload --workers 4 --host 0.0.0.0 --port 8000