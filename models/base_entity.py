from abc import ABC, abstractmethod

class BaseEntity(ABC):
    table: str; 
    primary_key: str = "id"
    fillable: list = list();
    
    def __init__(self, **kwargs) -> None:
        self.id = kwargs.get("id")
        for field in self.fillable:
            setattr(self, field, kwargs.get(field))
    
    
    @abstractmethod
    def to_dict(self) -> dict:
        """Convert entity to dictionary"""
        pass
    
    
    @classmethod
    @abstractmethod
    def from_dict(cls, data: dict):
        """Create entity from dictionary"""
        pass
    
    
    @abstractmethod
    def validate(self) -> bool:
        """Validate entity data"""
        pass
    
    
    def save(self):
        """Insert or update record"""
        pass
    
    
    def delete(self):
        """Delete record"""
        pass
    
    
    @classmethod
    def get_by_id(cls, id):
        """Find by primary key"""
        pass
    
