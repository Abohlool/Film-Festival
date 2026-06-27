from .human import Human
from database.database import DBConnection


class Staff(Human):
    """Concrete class for judges and coordinators"""

    table_name = "staff"
    fillable = ["name", "type", "specialization"]

    def __init__(self, db: DBConnection, **kwargs):
        super().__init__(**kwargs)

        self._db = db
        self.type = kwargs.get("type")
        self.specialization = kwargs.get("specialization")

        if self.type == "coordinator":
            self.specialization = None

    def get_type(self) -> str:
        return self.type

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "name": self.name,
            "type": self.type,
            "specialization": self.specialization,
        }

    @classmethod
    def from_dict(cls, db: DBConnection, data: dict):
        return cls(db=db, **data)

    def validate(self) -> bool:
        if self.type not in ("judge", "coordinator"):
            return False

        if not self.name:
            return False

        if self.type == "judge":
            return bool(self.specialization)

        return True

    def get_screenings(self) -> list:
        """Return screenings coordinated by this staff member."""

        if self.type != "coordinator":
            return []

        if self._db is None:
            raise ValueError("Database connection not set")

        query = """
            SELECT
                sc.id,
                sc.date,
                sc.time,
                sc.room,
                sc.capacity,
                f.title AS film
            FROM screening AS sc
            JOIN film AS f
                ON sc.film_id = f.id
            WHERE sc.coordinator_id = ?
        """
        return self._db.execute_query(query, (self.id,))

    def get_evaluations(self) -> list:
        """Return films evaluated by this judge."""

        if self.type != "judge":
            return []

        if self._db is None:
            raise ValueError("Database connection not set")

        query = """
            SELECT
                f.id,
                f.title,
                e.score,
                e.final_score
            FROM evaluation AS e
            JOIN film AS f
                ON e.film_id = f.id
            WHERE e.judge_id = ?
        """
        return self._db.execute_query(query, (self.id,))

    @classmethod
    def get_judges_with_more_than_5_evaluations(cls, db: DBConnection) -> list:
        """Return judges who have evaluated more than 5 films."""

        query = """
            SELECT
                s.id,
                s.name,
                s.specialization,
                COUNT(e.film_id) AS films_evaluated
            FROM staff AS s
            JOIN evaluation AS e
                ON s.id = e.judge_id
            WHERE s.type = 'judge'
            GROUP BY
                s.id,
                s.name,
                s.specialization
            HAVING COUNT(e.film_id) > 5
            ORDER BY films_evaluated DESC;
        """
        return db.execute_query(query)

    @classmethod
    def get_judges_without_evaluations(cls, db: DBConnection) -> list:
        """Return judges who have never evaluated a film."""

        query = """
            SELECT
                s.id,
                s.name,
                s.specialization
            FROM staff AS s
            LEFT JOIN evaluation AS e
                ON s.id = e.judge_id
            WHERE s.type = 'judge'
            AND e.judge_id IS NULL
            ORDER BY s.name;
        """
        return db.execute_query(query)

    def save(self):
        """Insert or update this staff member."""

        if self._db is None:
            raise ValueError("Database connection not set")

        if not self.validate():
            raise ValueError("Invalid staff data")

        if self.id:
            query = """
                UPDATE staff
                SET
                    name = ?,
                    type = ?,
                    specialization = ?
                WHERE id = ?
            """
            self._db.execute_query(
                query,
                (
                    self.name,
                    self.type,
                    self.specialization,
                    self.id,
                ),
            )
        else:
            query = """
                INSERT INTO staff
                    (name, type, specialization)
                VALUES (?, ?, ?)
            """

            self._db.execute_query(
                query,
                (
                    self.name,
                    self.type,
                    self.specialization,
                ),
            )
            result = self._db.execute_query("SELECT last_insert_rowid()")
            self.id = result[0][0]
