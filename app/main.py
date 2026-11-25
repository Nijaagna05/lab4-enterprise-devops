import os
from flask import Flask, jsonify

def create_app():
    app = Flask(__name__)

    @app.get("/")
    def index():
        return jsonify(
            service="lab4-enterprise-devops",
            version=os.getenv("APP_VERSION", "1.0.0"),
            environment=os.getenv("APP_ENV", "development"),
            message="Application is running"
        )

    @app.get("/health")
    def health():
        return jsonify(status="healthy"), 200

    @app.get("/ready")
    def ready():
        return jsonify(status="ready"), 200

    return app

app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "5000")))
