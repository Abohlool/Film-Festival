from .human import Human
from database.database import DBConnection


class Staff(Human):
    """Concrete class for judges and coordinators"""

    table_name = "staff"
    fillable = ["name", "type"]

    def __init__(self, db: DBConnection, **kwargs):
        super().__init__(**kwargs)
        self._db = db
        self.type = kwargs.get("type")

    def get_type(self) -> str:
        return self.type

    def to_dict(self) -> dict:
        return {"id": self.id, "name": self.name, "type": self.type}

    @classmethod
    def from_dict(cls, db: DBConnection, data: dict):
        return cls(db=db, **data)

    def validate(self) -> bool:
        return bool(self.name and self.type in ("judge", "coordinator"))

    def get_screenings(self):
        """Get screenings coordinated (if coordinator)"""
        pass

    def get_evaluations(self):
        """Get evaluations submitted (if judge)"""
        pass
