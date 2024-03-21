from functools import lru_cache
from pathlib import Path

from pydantic import AnyHttpUrl, BaseModel, SecretStr, computed_field
from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy.engine.url import URL

PROJECT_DIR = Path(__file__).parent.parent


class Security(BaseModel):
    ALLOWED_HOSTS: list[str] = ["localhost", "127.0.0.1"]
    BACKEND_CORS_ORIGINS: list[AnyHttpUrl] = []


class Server(BaseModel):
    SERVER_HOST: str = "localhost"
    SERVER_PORT: int = 8080
    SERVER_WORKERS: int = 1
    API_PREFIX: str = "/api"
    DOCS_URL: str = "/docs"
    OPENAPI_URL: str = "/openapi.json"
    REDOC_URL: str = "/redoc"
    OPENAPI_PREFIX: str = ""
    DEBUG: bool = True


class Database(BaseModel):
    HOSTNAME: str = "postgres"
    USERNAME: str = "postgres"
    PASSWORD: SecretStr
    PORT: int = 5432
    DB: str = "postgres"

    @computed_field  # type: ignore[misc]
    @property
    def sqlalchemy_uri(self) -> URL:
        return URL.create(
            drivername="postgresql+asyncpg",
            username=self.USERNAME,
            password=self.PASSWORD.get_secret_value(),
            host=self.HOSTNAME,
            port=self.PORT,
            database=self.DB,
        )


class Settings(BaseSettings):
    security: Security
    server: Server
    database: Database

    model_config = SettingsConfigDict(
        env_file=f"{PROJECT_DIR}/.env",
        case_sensitive=False,
        env_nested_delimiter="__",
    )


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    return Settings()  # type: ignore
