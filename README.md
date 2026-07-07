# Film Festival Database Browser

![Python](https://img.shields.io/badge/Python-3.8+-blue?logo=python&logoColor=white)
![PySide6](https://img.shields.io/badge/PySide6-6.5+-green?logo=qt&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-3-lightgrey?logo=sqlite&logoColor=white)

A PySide6 desktop application for browsing and managing a film festival SQLite database.

## Features

- Browse database tables and views
- Add, edit, and delete records
- Execute 16 predefined analytical queries
- Run custom SQL queries
- Collapsible query panel

## Project Structure

```Text
.
├── main.py                             # Application entry point
├── festival.db                         # SQLite database
├── requirements.txt                    # Python dependencies
├── core/
│ ├── init.py                           # Package initialization
│ ├── main_window.py                    # Main application window and UI
│ ├── collapsible_panel.py              # Collapsible panel widget
│ ├── table_model.py                    # Custom table model for QTableView
│ ├── record_dialog.py                  # Dialog for adding/editing records
│ └── query_loader.py                   # Loads queries from JSON file
├── database/
│ ├── queries.json                      # Predefined queries
│ ├── queries.sql                       # SQL queries (reference)
│ ├── schema.sql                        # Database schema
│ └── seed.sql                          # Seed data
└── docs/
├── DESIGN.md                           # Design document
├── EERD.pdf                            # Entity-Relationship diagram
└── relational_model.pdf                # Relational model
```

## Setup

### Clone the repository

```Bash
git clone https://github.com/Abohlool/film-festival-db.git
cd film-festival-db
```

### Or download and extract

```Bash
wget https://github.com/Abohlool/film-festival-db/archive/refs/heads/main.zip
unzip main.zip
cd film-festival-db-main
```

### Install dependencies

```Bash
pip install -r requirements.txt
```

### Initialize the database

```Bash
sqlite3 festival.db < database/schema.sql
sqlite3 festival.db < database/seed.sql
```

### Run the application

```Bash
python main.py
```

## Requirements

- Python 3.8+
- PySide6

## License

MIT
