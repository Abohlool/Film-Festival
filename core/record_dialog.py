from PySide6.QtWidgets import QVBoxLayout, QFormLayout, QDialog, QSpinBox, QLineEdit, QDialogButtonBox, QMessageBox


class RecordDialog(QDialog):
    
    def __init__(self, table_name, columns, record=None, parent=None):
        super().__init__(parent)
        self.table_name = table_name
        self.columns = columns
        self.record = record
        self.fields = {}
        self.setWindowTitle(f"{'Edit' if record else 'Add'} Record - {table_name}")
        self.setMinimumWidth(400)
        self.init_ui()
    
    
    def init_ui(self):
        layout = QVBoxLayout(self)
        
        form_layout = QFormLayout()
        
        for i, col in enumerate(self.columns):
            col_name = col[1]
            col_type = col[2].upper()
            
            if col_name.lower() == 'id':
                continue
            
            if 'INTEGER' in col_type or 'INT' in col_type:
                widget = QSpinBox()
                widget.setRange(-999999, 999999)
                if self.record and i < len(self.record) and self.record[i] is not None:
                    widget.setValue(int(self.record[i]))
            elif 'TEXT' in col_type:
                widget = QLineEdit()
                if self.record and i < len(self.record) and self.record[i] is not None:
                    widget.setText(str(self.record[i]))
            elif 'DATE' in col_type:
                widget = QLineEdit()
                widget.setPlaceholderText("YYYY-MM-DD")
                if self.record and i < len(self.record) and self.record[i] is not None:
                    widget.setText(str(self.record[i]))
            elif 'TIME' in col_type:
                widget = QLineEdit()
                widget.setPlaceholderText("HH:MM")
                if self.record and i < len(self.record) and self.record[i] is not None:
                    widget.setText(str(self.record[i]))
            else:
                widget = QLineEdit()
                if self.record and i < len(self.record) and self.record[i] is not None:
                    widget.setText(str(self.record[i]))
            
            self.fields[col_name] = widget
            form_layout.addRow(f"{col_name}:", widget)
        
        layout.addLayout(form_layout)
        
        button_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        button_box.accepted.connect(self.validate_and_accept)
        button_box.rejected.connect(self.reject)
        layout.addWidget(button_box)
    
    
    def validate_and_accept(self):
        for col_name, widget in self.fields.items():
            if isinstance(widget, QLineEdit) and widget.text().strip() == "":
                reply = QMessageBox.question(
                    self, 
                    "Empty Field", 
                    f"Field '{col_name}' is empty. Do you want to continue?",
                    QMessageBox.Yes | QMessageBox.No
                )
                if reply == QMessageBox.No:
                    return
        
        self.accept()
    
    
    def get_values(self):
        values = {}
        for col_name, widget in self.fields.items():
            if isinstance(widget, QSpinBox):
                values[col_name] = widget.value()
            elif isinstance(widget, QLineEdit):
                text = widget.text().strip()
                values[col_name] = text if text else None
        return values
    
