import sys
from PySide6.QtWidgets import QApplication
from core.main_window import MainWindow


app = QApplication(sys.argv)
app.setStyle('Fusion')

window = MainWindow()
window.show()

sys.exit(app.exec())
