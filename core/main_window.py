from PySide6.QtWidgets import (
    QMainWindow, QWidget, QVBoxLayout, 
    QHBoxLayout, QSplitter, QListWidget, QListWidgetItem,
    QTableView, QHeaderView, QMessageBox,
    QInputDialog, QLabel, QStatusBar, QPushButton,
    QTreeWidget, QTreeWidgetItem,
    QDialog,
)

from PySide6.QtCore import Qt
from PySide6.QtGui import QFont

from .collapsible_panel import CollapsiblePanel
from .table_model import TableModel
from .record_dialog import RecordDialog
from .query_loader import QueryLoader

import sqlite3

class MainWindow(QMainWindow):
    
    def __init__(self):
        super().__init__()
        self.db_path = "festival.db"
        self.current_table = None
        self.current_columns = None
        
        self.query_loader = QueryLoader()
        
        self.init_ui()
        self.load_tables()
        self.load_queries()
    
    
    def init_ui(self):
        self.setWindowTitle("Film Festival Database Browser")
        self.setGeometry(100, 100, 1400, 800)
        
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        main_layout = QHBoxLayout(central_widget)
        main_layout.setContentsMargins(5, 5, 5, 5)
        
        main_splitter = QSplitter(Qt.Horizontal)
        
        left_panel = QWidget()
        left_layout = QVBoxLayout(left_panel)
        left_layout.setContentsMargins(0, 0, 0, 0)
        
        tables_label = QLabel("Database Tables")
        tables_label.setFont(QFont("Arial", 12, QFont.Bold))
        left_layout.addWidget(tables_label)
        
        self.tables_tree = QTreeWidget()
        self.tables_tree.setHeaderLabel("Tables & Views")
        self.tables_tree.itemClicked.connect(self.on_table_clicked)
        left_layout.addWidget(self.tables_tree)
        
        center_panel = QWidget()
        center_layout = QVBoxLayout(center_panel)
        center_layout.setContentsMargins(0, 0, 0, 0)
        
        self.results_label = QLabel("Select a table to view or a query to execute")
        self.results_label.setFont(QFont("Arial", 12, QFont.Bold))
        center_layout.addWidget(self.results_label)
        
        button_layout = QHBoxLayout()
        
        self.add_button = QPushButton("➕ Add Record")
        self.add_button.setFont(QFont("Arial", 10))
        self.add_button.clicked.connect(self.add_record)
        self.add_button.setEnabled(False)
        
        self.edit_button = QPushButton("✏️ Edit Record")
        self.edit_button.setFont(QFont("Arial", 10))
        self.edit_button.clicked.connect(self.edit_record)
        self.edit_button.setEnabled(False)
        
        self.delete_button = QPushButton("🗑️ Delete Record")
        self.delete_button.setFont(QFont("Arial", 10))
        self.delete_button.clicked.connect(self.delete_record)
        self.delete_button.setEnabled(False)
        
        self.refresh_button = QPushButton("🔄 Refresh")
        self.refresh_button.setFont(QFont("Arial", 10))
        self.refresh_button.clicked.connect(self.refresh_table)
        self.refresh_button.setEnabled(False)
        
        button_layout.addWidget(self.add_button)
        button_layout.addWidget(self.edit_button)
        button_layout.addWidget(self.delete_button)
        button_layout.addWidget(self.refresh_button)
        button_layout.addStretch()
        
        center_layout.addLayout(button_layout)
        
        self.table_view = QTableView()
        self.table_view.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.table_view.setAlternatingRowColors(True)
        self.table_view.setSortingEnabled(True)
        self.table_view.setSelectionBehavior(QTableView.SelectRows)
        self.table_view.setSelectionMode(QTableView.SingleSelection)
        center_layout.addWidget(self.table_view)
        
        self.right_panel = CollapsiblePanel("Queries")
        self.right_panel.setMinimumWidth(250)
        self.right_panel.setMaximumWidth(400)
        
        self.query_list = QListWidget()
        self.query_list.itemClicked.connect(self.execute_query)
        self.right_panel.add_widget(self.query_list)
        
        main_splitter.addWidget(left_panel)
        main_splitter.addWidget(center_panel)
        main_splitter.addWidget(self.right_panel)
        main_splitter.setSizes([250, 800, 350])
        
        main_layout.addWidget(main_splitter)
        
        self.status_bar = QStatusBar()
        self.setStatusBar(self.status_bar)
        self.status_bar.showMessage("Ready")
    
    
    def show_about(self):
        QMessageBox.about(
            self,
            "About Film Festival Database Browser",
            "Film Festival Database Browser\n\n"
            "A PySide6 application for browsing and managing\n"
            "a film festival database.\n\n"
            f"Loaded queries: {self.query_loader.get_query_count()}"
        )
    
    
    def load_tables(self):
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute("""
                SELECT name FROM sqlite_master 
                WHERE type='table' 
                AND name NOT LIKE 'sqlite_%'
                ORDER BY name
            """)
            tables = cursor.fetchall()
            
            cursor.execute("""
                SELECT name FROM sqlite_master 
                WHERE type='view'
                ORDER BY name
            """)
            views = cursor.fetchall()
            
            self.tables_tree.clear()
            
            tables_root = QTreeWidgetItem(self.tables_tree, ["Tables"])
            tables_root.setFont(0, QFont("Arial", 10, QFont.Bold))
            
            for table in tables:
                item = QTreeWidgetItem(tables_root, [table[0]])
                item.setData(0, Qt.UserRole, {"type": "table", "name": table[0]})
                item.setFont(0, QFont("Arial", 10))
            
            if views:
                views_root = QTreeWidgetItem(self.tables_tree, ["Views"])
                views_root.setFont(0, QFont("Arial", 10, QFont.Bold))
                
                for view in views:
                    item = QTreeWidgetItem(views_root, [view[0]])
                    item.setData(0, Qt.UserRole, {"type": "view", "name": view[0]})
                    item.setFont(0, QFont("Arial", 10))
            
            self.tables_tree.expandAll()
            
            cursor.close()
            conn.close()
            
            self.status_bar.showMessage(
                f"Loaded {len(tables)} tables and {len(views)} views"
            )
            
        except sqlite3.Error as e:
            QMessageBox.critical(
                self, 
                "Database Error", 
                f"Error loading tables:\n{str(e)}"
            )
    
    
    def on_table_clicked(self, item, column):
        data = item.data(0, Qt.UserRole)
        if data is None:
            return
        
        table_name = data["name"]
        table_type = data["type"]
        
        if table_type == "table":
            self.current_table = table_name
            self.add_button.setEnabled(True)
            self.edit_button.setEnabled(True)
            self.delete_button.setEnabled(True)
            self.refresh_button.setEnabled(True)
        else:
            self.current_table = None
            self.add_button.setEnabled(False)
            self.edit_button.setEnabled(False)
            self.delete_button.setEnabled(False)
            self.refresh_button.setEnabled(True)
        
        self.view_table(table_name)
    
    
    def view_table(self, table_name):
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute(f"PRAGMA table_info(`{table_name}`)")
            self.current_columns = cursor.fetchall()
            
            cursor.execute(f"SELECT COUNT(*) FROM `{table_name}`")
            row_count = cursor.fetchone()[0]
            
            cursor.execute(f"SELECT * FROM `{table_name}`")
            data = cursor.fetchall()
            headers = [description[0] for description in cursor.description]
            
            if not hasattr(self, 'table_model'):
                self.table_model = TableModel(data, headers)
                self.table_view.setModel(self.table_model)
            else:
                self.table_model.update_data(data, headers)
            
            self.results_label.setText(f"Table: {table_name} - {row_count} rows")
            self.status_bar.showMessage(f"Showing table '{table_name}' - {row_count} rows")
            
            cursor.close()
            conn.close()
            
        except sqlite3.Error as e:
            QMessageBox.critical(
                self, 
                "Database Error", 
                f"Error viewing table '{table_name}':\n{str(e)}"
            )
            self.status_bar.showMessage("Error loading table")
    
    
    def add_record(self):
        if not self.current_table or not self.current_columns:
            return
        
        dialog = RecordDialog(self.current_table, self.current_columns, parent=self)
        if dialog.exec() == QDialog.Accepted:
            values = dialog.get_values()
            
            try:
                conn = sqlite3.connect(self.db_path)
                cursor = conn.cursor()
                
                columns = ', '.join([f"`{col}`" for col in values.keys()])
                placeholders = ', '.join(['?' for _ in values])
                query = f"INSERT INTO `{self.current_table}` ({columns}) VALUES ({placeholders})"
                
                cursor.execute(query, list(values.values()))
                conn.commit()
                
                QMessageBox.information(self, "Success", "Record added successfully!")
                self.refresh_table()
                
                cursor.close()
                conn.close()
                
            except sqlite3.Error as e:
                QMessageBox.critical(
                    self, 
                    "Database Error", 
                    f"Error adding record:\n{str(e)}"
                )
    
    
    def edit_record(self):
        if not self.current_table or not self.current_columns:
            return
        
        selection_model = self.table_view.selectionModel()
        if not selection_model.hasSelection():
            QMessageBox.warning(
                self, 
                "No Selection", 
                "Please select a record to edit."
            )
            return
        
        selected_row = selection_model.selectedRows()[0].row()
        record_id = self.table_model._data[selected_row][0]
        
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute(
                f"SELECT * FROM `{self.current_table}` WHERE `id` = ?", 
                (record_id,)
            )
            record = cursor.fetchone()
            
            dialog = RecordDialog(
                self.current_table, 
                self.current_columns, 
                record, 
                parent=self
            )
            
            if dialog.exec() == QDialog.Accepted:
                values = dialog.get_values()
                
                set_clause = ', '.join([f"`{col}` = ?" for col in values.keys()])
                query = f"UPDATE `{self.current_table}` SET {set_clause} WHERE `id` = ?"
                
                cursor.execute(query, list(values.values()) + [record_id])
                conn.commit()
                
                QMessageBox.information(
                    self, 
                    "Success", 
                    "Record updated successfully!"
                )
                self.refresh_table()
            
            cursor.close()
            conn.close()
            
        except sqlite3.Error as e:
            QMessageBox.critical(
                self, 
                "Database Error", 
                f"Error editing record:\n{str(e)}"
            )
    
    
    def delete_record(self):
        if not self.current_table:
            return
        
        selection_model = self.table_view.selectionModel()
        if not selection_model.hasSelection():
            QMessageBox.warning(
                self, 
                "No Selection", 
                "Please select a record to delete."
            )
            return
        
        reply = QMessageBox.question(
            self,
            "Confirm Deletion",
            "Are you sure you want to delete this record?\n"
            "This action cannot be undone!",
            QMessageBox.Yes | QMessageBox.No,
            QMessageBox.No
        )
        
        if reply != QMessageBox.Yes:
            return
        
        selected_row = selection_model.selectedRows()[0].row()
        record_id = self.table_model._data[selected_row][0]
        
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute(
                f"DELETE FROM `{self.current_table}` WHERE `id` = ?", 
                (record_id,)
            )
            conn.commit()
            
            QMessageBox.information(
                self, 
                "Success", 
                "Record deleted successfully!"
            )
            self.refresh_table()
            
            cursor.close()
            conn.close()
            
        except sqlite3.Error as e:
            QMessageBox.critical(
                self, 
                "Database Error", 
                f"Error deleting record:\n{str(e)}"
            )
    
    
    def refresh_table(self):
        if self.current_table:
            self.view_table(self.current_table)
        else:
            current_text = self.results_label.text()
            if "Table:" in current_text:
                table_name = current_text.split("Table: ")[1].split(" -")[0]
                self.view_table(table_name)
    
    
    def load_queries(self):
        try:
            self.queries = self.query_loader.get_queries()
            
            self.query_list.clear()
            
            for query_info in self.queries:
                item = QListWidgetItem(query_info["name"])
                item.setData(Qt.UserRole, query_info)
                self.query_list.addItem(item)
            
            self.right_panel.collapse()
            
            self.status_bar.showMessage(
                f"Loaded {len(self.queries)} queries from database/queries.json"
            )
        
        except FileNotFoundError as e:
            QMessageBox.warning(
                self, 
                "Queries File Not Found", 
                f"Could not load queries:\n{str(e)}\n\n"
                "The application will continue without predefined queries.\n"
                "Please ensure database/queries.json exists."
            )
            self.status_bar.showMessage("No queries loaded - file not found")
        
        except ValueError as e:
            QMessageBox.warning(
                self, 
                "Invalid Queries File", 
                f"Error loading queries:\n{str(e)}\n\n"
                "Please check the JSON format of database/queries.json"
            )
            self.status_bar.showMessage("Error loading queries")
        
        except Exception as e:
            QMessageBox.critical(
                self, 
                "Error", 
                f"Unexpected error loading queries:\n{str(e)}"
            )
            self.status_bar.showMessage("Error loading queries")
    
    
    def execute_query(self, item):
        query_info = item.data(Qt.UserRole)
        
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            params = []
            
            if query_info["params_prompt"]:
                param_value, ok = QInputDialog.getText(
                    self, 
                    "Parameter Required", 
                    query_info["params_prompt"]
                )
                
                if not ok:
                    self.status_bar.showMessage("Query cancelled")
                    return
                
                try:
                    if query_info["params_type"] == int:
                        param_value = int(param_value)
                    params = [param_value]
                except ValueError:
                    QMessageBox.warning(
                        self, 
                        "Invalid Input", 
                        f"Please enter a valid {query_info['params_type'].__name__}"
                    )
                    return
            
            cursor.execute(query_info["query"], params)
            data = cursor.fetchall()
            headers = [description[0] for description in cursor.description]
            
            if not hasattr(self, 'table_model'):
                self.table_model = TableModel(data, headers)
                self.table_view.setModel(self.table_model)
            else:
                self.table_model.update_data(data, headers)
            
            self.results_label.setText(
                f"Query: {query_info['name']} - {len(data)} results"
            )
            self.status_bar.showMessage(
                f"Query executed successfully - {len(data)} rows returned"
            )
            
            self.current_table = None
            self.add_button.setEnabled(False)
            self.edit_button.setEnabled(False)
            self.delete_button.setEnabled(False)
            self.refresh_button.setEnabled(False)
            
            if self.right_panel.is_collapsed:
                self.right_panel.expand()
            
            cursor.close()
            conn.close()
            
        except sqlite3.Error as e:
            QMessageBox.critical(
                self, 
                "Database Error", 
                f"Error executing query:\n{str(e)}"
            )
            self.status_bar.showMessage("Query failed")
        except Exception as e:
            QMessageBox.critical(
                self, 
                "Error", 
                f"An unexpected error occurred:\n{str(e)}"
            )
            self.status_bar.showMessage("Query failed")
    