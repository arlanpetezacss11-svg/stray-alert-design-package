"""Populate the database with demo data: `python seed.py`"""
from datetime import date, datetime, timedelta

from strayalert import create_app, db
from strayalert.models import Pet, Report, User

app = create_app()

with app.app_context():
    if User.query.first():
        print("Database already has data; nothing to do.")
        raise SystemExit

    admin = User(name="Dr. Cruz", email="admin@vetclinic.com", phone="0917 123 4567", address="Main Street Veterinary Clinic", is_admin=True)
    admin.set_password("admin123")
    maria = User(name="Maria Santos", email="maria@example.com", phone="0917 123 4567", address="123 Main St, City")
    maria.set_password("password")
    juan = User(name="Juan dela Cruz", email="juan@example.com", phone="0918 765 4321", address="456 Oak Ave, City")
    juan.set_password("password")
    db.session.add_all([admin, maria, juan])

    pets = [
        Pet(owner=maria, name="Bantay", species="Dog", breed="Aspin", sex="Male", color="Brown with white chest", age_years=3,
            description="Friendly, answers to his name. Red collar.", vaccinated=True, vaccine_name="Anti-rabies",
            last_vaccination_date=date.today() - timedelta(days=90)),
        Pet(owner=maria, name="Mingming", species="Cat", breed="Puspin", sex="Female", color="Orange tabby", age_years=2,
            description="Shy around strangers.", vaccinated=False),
        Pet(owner=juan, name="Choco", species="Dog", breed="Shih Tzu", sex="Male", color="Brown and white", age_years=5,
            description="Small, long hair. Likes treats.", vaccinated=True, vaccine_name="Anti-rabies + 5-in-1",
            last_vaccination_date=date.today() - timedelta(days=200), status=Pet.STATUS_LOST),
    ]
    db.session.add_all(pets)
    db.session.flush()

    db.session.add_all([
        Report(type=Report.TYPE_LOST, pet=pets[2], reporter=juan, reporter_name=juan.name, reporter_contact=juan.phone,
               description="Choco ran out of the gate.", location="456 Oak Ave, near the park",
               happened_at=datetime.utcnow() - timedelta(hours=20)),
        Report(type=Report.TYPE_FOUND, reporter_name="Ana Reyes", reporter_contact="0920 555 1234",
               description="Found a small white dog with a blue collar wandering near the market. Keeping it at our house for now.",
               location="City Public Market", happened_at=datetime.utcnow() - timedelta(hours=3)),
    ])
    db.session.commit()
    print("Seeded demo data. Log in with admin@vetclinic.com / admin123 (admin), maria@example.com / password, or juan@example.com / password")
