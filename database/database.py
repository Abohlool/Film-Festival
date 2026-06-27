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
    
    Examples:
        >>> # Basic initialization with default paths
        >>> db = DBConnection()
        
        >>> # Custom database and schema paths
        >>> db = DBConnection(
        ...     db_path="./database/festival.db",
        ...     schema_path="./database/schema.sql"
        ... )
        
        >>> # Load sample data from file
        >>> db.feed_sample(seed_path="./database/seed.sql")
        
        >>> # Load sample data from string
        >>> seed_sql = '''
        ... INSERT INTO category (name) VALUES
        ... ('Best Picture'),
        ... ('Best Director');
        ... '''
        >>> db.feed_sample(seed=seed_sql)
        
        >>> # Execute a query
        >>> results = db.execute_query(
        ...     "SELECT * FROM film WHERE year = ?", 
        ...     (2025,)
        ... )
        
        >>> # Get raw connection for complex operations
        >>> conn = db.get_connection()
        >>> cursor = conn.cursor()
        >>> cursor.execute("SELECT COUNT(*) FROM person")
        >>> cursor.close()
        >>> conn.close()
        
        >>> # Reset database during development
        >>> db.reset_database()
        
        >>> # Disable auto-initialization for manual control
        >>> db = DBConnection(auto_init=False)
        >>> # ... do something else ...
        >>> db._init_schema()
    """
    
    def __init__(self, db_path: str = "./festival.db", schema_path: str = "./schema.sql", auto_init: bool = True):
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
            with sqlite3.connect(self.db_path) as db:
                cursor = db.cursor()
                cursor.execute("PRAGMA foreign_keys = ON;")
                
                with open(self.schema_path, "r") as schema_file:
                    schema_script = schema_file.read()
                cursor.executescript(schema_script)
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
            with sqlite3.connect(self.db_path) as db:
                cursor = db.cursor()
                cursor.execute("PRAGMA foreign_keys = ON;")
                
                if seed_path is not None:
                    with open(seed_path, "r") as seed_file:
                        seed_script = seed_file.read()
                    cursor.executescript(seed_script)
                    print(f"Sample data loaded from {seed_path}")
                
                elif seed is not None:
                    cursor.executescript(seed)
                    print("Sample data loaded from string")
                    
        except FileNotFoundError:
            print(f"Error: Seed file not found at {seed_path}")
        except Exception as e:
            print(f"Error feeding sample data: {e}")
    
    
    def get_connection(self):
        """Get a new database connection."""
        connection = sqlite3.connect(self.db_path)
        connection.execute("PRAGMA foreign_keys = ON;")
        return connection
    
    
    def execute_query(self, query: str, params: tuple = ()):
        """Execute a query and return results."""
        with sqlite3.connect(self.db_path) as db:
            cursor = db.cursor()
            cursor.execute(query, params)
            return cursor.fetchall()
    
    
    def reset_database(self):
        """Drop all tables and reinitialize schema."""
        if os.path.exists(self.db_path):
            os.remove(self.db_path)
            print(f"Database {self.db_path} deleted")
        self._init_schema()
        print("Database reset complete")
    
