from .human import Human
from database.database import DBConnection

class Person(Human):
    """Concrete class for directors and actors"""
    
    table_name = "person"
    fillable = ["name", "type"]
    
    def __init__(self, db: DBConnection, **kwargs):
        super().__init__(**kwargs)
        self._db = db
        self.type = kwargs.get("type")
    
    
    def get_type(self) -> str:
        return self.type
    
    
    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "name": self.name,
            "type": self.type,
        }
    
    
    @classmethod
    def from_dict(cls, db: DBConnection, data: dict):
        return cls(db=db, **data)
    
    
    def validate(self) -> bool:
        return bool(
            self.name and
            self.type in ("director", "actor")
        )
    
    
    def get_films_directed(self):
        """Return all films directed by this person."""
        if self.type != "director":
            return []
        
        if self._db is None:
            raise ValueError("Database connection not set")
        
        query = """
            SELECT `f`.*
            FROM `film` AS `f`
            JOIN `film_director` AS `fd`
                ON f.id = fd.film_id
            WHERE fd.director_id = ?
        """

        return self._db.execute_query(query, (self.id,))

    def get_films_acted(self):
        """Return all films acted in by this person."""
        if self.type != "actor":
            return []

        if self._db is None:
            raise ValueError("Database connection not set")

        query = """
            SELECT f.*
            FROM film AS f
            JOIN film_actor AS fa
                ON f.id = fa.film_id
            WHERE fa.actor_id = ?
        """

        return self._db.execute_query(query, (self.id,))

    def save(self):
        """Insert or update this person."""
        if self._db is None:
            raise ValueError("Database connection not set")

        if not self.validate():
            raise ValueError("Invalid person data")

        if self.id:
            query = """
                UPDATE person
                SET name = ?, type = ?
                WHERE id = ?
            """
            self._db.execute_query(query, (self.name, self.type, self.id))

        else:
            query = """
                INSERT INTO person (name, type)
                VALUES (?, ?)
            """
            self._db.execute_query(query, (self.name, self.type))

            result = self._db.execute_query(
                "SELECT last_insert_rowid()"
            )
            self.id = result[0][0]
    
