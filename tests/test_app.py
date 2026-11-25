from app.main import create_app

def test_home_endpoint():
    client = create_app().test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.json["service"] == "lab4-enterprise-devops"

def test_health_endpoint():
    client = create_app().test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json["status"] == "healthy"

def test_ready_endpoint():
    client = create_app().test_client()
    response = client.get("/ready")
    assert response.status_code == 200
    assert response.json["status"] == "ready"
