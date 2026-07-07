from PySide6.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QFrame, QLabel, QPushButton
from PySide6.QtCore import Qt, QPropertyAnimation, QEasingCurve
from PySide6.QtGui import QFont


class CollapsiblePanel(QWidget):
    
    def __init__(self, title="", parent=None):
        super().__init__(parent)
        self.animation = None
        self.is_collapsed = False
        self.content_height = 0
        
        self.main_layout = QVBoxLayout(self)
        self.main_layout.setContentsMargins(0, 0, 0, 0)
        self.main_layout.setSpacing(0)
        
        self.header_widget = QFrame()
        self.header_widget.setFrameStyle(QFrame.StyledPanel | QFrame.Raised)
        self.header_widget.setCursor(Qt.PointingHandCursor)
        header_layout = QHBoxLayout(self.header_widget)
        header_layout.setContentsMargins(10, 5, 10, 5)
        
        self.title_label = QLabel(title)
        self.title_label.setFont(QFont("Arial", 11, QFont.Bold))
        
        self.toggle_button = QPushButton("◀")
        self.toggle_button.setFixedSize(30, 30)
        self.toggle_button.setFont(QFont("Arial", 14))
        self.toggle_button.clicked.connect(self.toggle_collapse)
        
        header_layout.addWidget(self.title_label)
        header_layout.addStretch()
        header_layout.addWidget(self.toggle_button)
        
        self.main_layout.addWidget(self.header_widget)
        
        self.content_widget = QWidget()
        self.content_layout = QVBoxLayout(self.content_widget)
        self.content_layout.setContentsMargins(5, 5, 5, 5)
        
        self.main_layout.addWidget(self.content_widget)
        
        self.animation = QPropertyAnimation(self.content_widget, b"maximumHeight")
        self.animation.setDuration(300)
        self.animation.setEasingCurve(QEasingCurve.InOutQuad)
    
    
    def add_widget(self, widget):
        self.content_layout.addWidget(widget)
    
    
    def toggle_collapse(self):
        if self.is_collapsed:
            self.expand()
        else:
            self.collapse()
    
    
    def collapse(self):
        if not self.is_collapsed:
            self.content_height = self.content_widget.height()
            self.animation.setStartValue(self.content_height)
            self.animation.setEndValue(0)
            self.animation.start()
            self.toggle_button.setText("▶")
            self.is_collapsed = True
    
    
    def expand(self):
        if self.is_collapsed:
            self.animation.setStartValue(0)
            self.animation.setEndValue(self.content_height if self.content_height > 0 else 500)
            self.animation.start()
            self.toggle_button.setText("◀")
            self.is_collapsed = False
    
    
    def set_title(self, title):
        self.title_label.setText(title)
    
