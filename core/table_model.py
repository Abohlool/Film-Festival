from PySide6.QtGui import QColor, QBrush
from PySide6.QtCore import Qt, QAbstractTableModel, QModelIndex


class TableModel(QAbstractTableModel):
    
    def __init__(self, data=None, headers=None):
        super().__init__()
        self._data = data or []
        self._headers = headers or []
    
    
    def rowCount(self, parent=QModelIndex()):
        return len(self._data)
    
    
    def columnCount(self, parent=QModelIndex()):
        return len(self._headers) if self._data else 0
    
    
    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return None
        
        if role == Qt.DisplayRole:
            value = self._data[index.row()][index.column()]
            return str(value) if value is not None else ""
        
        if role == Qt.BackgroundRole and index.row() % 2 == 0:
            return QBrush(QColor(240, 240, 245))
        
        return None
    
    
    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if role == Qt.DisplayRole:
            if orientation == Qt.Horizontal and section < len(self._headers):
                return self._headers[section]
            if orientation == Qt.Vertical:
                return str(section + 1)
        return None
    
    
    def update_data(self, data, headers):
        self.beginResetModel()
        self._data = data or []
        self._headers = headers or []
        self.endResetModel()
    
