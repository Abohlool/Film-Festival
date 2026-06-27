from abc import ABC, abstractmethod
from .base_entity import BaseEntity

class Human(BaseEntity, ABC):
    """Abstract class for human entities (Person, Staff)"""
    
    fillable: list = ["name"]
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.name = kwargs.get('name')
    
    
    @abstractmethod
    def get_type(self) -> str:
        """Return the specific type (director/actor/judge/coordinator)"""
        pass
    
    
    @abstractmethod
    def __str__(self) -> str:
        """Format name for display"""
        return f"{self.name} ({self.get_type()})"
    
    
    def search_by_name(self, query: str):
        """Search humans by name"""
        pass
    

