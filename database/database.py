import sqlite3
import os
from typing import Optional


class DBConnection:
    """
    Manages SQLite database connection, schema initialization, and data seeding.

    Provides a high-level interface for database operations including:
    - Automatic schema creation from SQL files
    - Sample data insertion from files or raw SQL strings
    - Connection management with foreign key enforcement
    - Database reset capabilities for development

    Attributes:
        db_path (str): Path to the SQLite database file
        schema_path (str): Path to the schema SQL file
    """

    def __init__(
        self,
        db_path: str = "./festival.db",
        schema_path: str = "./schema.sql",
        auto_init: bool = True,
    ):
        """
        Initialize database connection.

        Args:
            db_path: Path to SQLite database file
            schema_path: Path to schema SQL file
            auto_init: Automatically create tables if True
        """
        self.db_path = db_path
        self.schema_path = schema_path

        if auto_init:
            self._init_schema()

    def _init_schema(self):
        """Create tables from schema file."""
        try:
            with self.get_connection() as connection:
                connection.execute("PRAGMA foreign_keys = ON;")

                with open(self.schema_path, "r") as schema_file:
                    connection.executescript(schema_file.read())
                print(f"Schema initialized from {self.schema_path}")
        except FileNotFoundError:
            print(f"Warning: Schema file not found at {self.schema_path}")
        except Exception as e:
            print(f"Error initializing schema: {e}")

    def feed_sample(self, seed_path: Optional[str] = None, seed: Optional[str] = None):
        """
        Insert sample data into database.

        Args:
            seed_path: Path to seed SQL file
            seed: Raw SQL string to execute
        """
        if seed_path is None and seed is None:
            raise TypeError("Must provide at least one of (seed_path, seed)")

        try:
            with self.get_connection() as connection:
                connection.execute("PRAGMA foreign_keys = ON;")

                if seed_path is not None:
                    with open(seed_path, "r") as seed_file:
                        connection.executescript(seed_file.read())
                    print(f"Sample data loaded from {seed_path}")

                elif seed is not None:
                    connection.executescript(seed)
                    print("Sample data loaded from string")

        except FileNotFoundError:
            print(f"Error: Seed file not found at {seed_path}")
        except Exception as e:
            print(f"Error feeding sample data: {e}")

    def get_connection(self) -> sqlite3.Connection:
        """Get a new database connection."""
        connection = sqlite3.connect(self.db_path)
        connection.execute("PRAGMA foreign_keys = ON;")
        connection.row_factory = sqlite3.Row
        return connection

    def execute(self, query: str, params: tuple = tuple()):
        """Execute a query and return results."""
        with self.get_connection() as connection:
            connection.execute(query, params)
            connection.commit()

    def fetchone(self, query: str, params: tuple = tuple()) -> sqlite3.Row | None:
        with self.get_connection() as connection:
            return connection.execute(query, params).fetchone()

    def fetchall(self, query: str, params: tuple = tuple()) -> list[sqlite3.Row]:
        with self.get_connection() as connection:
            return connection.execute(query, params).fetchall()

    def executemany(self, query: str, params: list[tuple] = [tuple()]):
        with self.get_connection() as connection:
            connection.executemany(query, params)
            connection.commit()

    def insert(self, query: str, params: tuple = tuple()) -> int:
        with self.get_connection() as connection:
            cursor = connection.execute(query, params)
            connection.commit()
            return cursor.lastrowid

    def reset_database(self):
        """Drop all tables and reinitialize schema."""
        if os.path.exists(self.db_path):
            os.remove(self.db_path)
            print(f"Database {self.db_path} deleted")
        self._init_schema()
        print("Database reset complete")
