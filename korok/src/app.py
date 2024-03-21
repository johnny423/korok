import fastapi
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.trustedhost import TrustedHostMiddleware

from korok.src.config import get_settings


def initialize_backend_application() -> fastapi.FastAPI:
    app = fastapi.FastAPI(**settings.set_backend_app_attributes)  # type: ignore

    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in get_settings().security.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.add_middleware(
        TrustedHostMiddleware,
        allowed_hosts=get_settings().security.ALLOWED_HOSTS,
    )

    return app


backend_app: fastapi.FastAPI = initialize_backend_application()

if __name__ == "__main__":
    settings = get_settings()
    uvicorn.run(
        app="app:backend_app",
        host=settings.server.SERVER_HOST,
        port=settings.server.SERVER_PORT,
        reload=settings.server.DEBUG,
        workers=settings.server.SERVER_WORKERS,
    )
