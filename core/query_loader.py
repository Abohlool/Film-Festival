import json
from pathlib import Path
from typing import List, Dict, Optional, Any


class QueryLoader:
    
    def __init__(self, json_path: Optional[str] = None):
        self.json_path = json_path or self._find_queries_file()
        self._queries: List[Dict[str, Any]] = []
    
    
    def _find_queries_file(self) -> str:
        core_dir = Path(__file__).parent
        project_root = core_dir.parent
        
        json_file = project_root / "database" / "queries.json"
        
        if json_file.exists():
            return str(json_file)
        
        cwd_file = Path.cwd() / "database" / "queries.json"
        if cwd_file.exists():
            return str(cwd_file)
        
        raise FileNotFoundError(
            "queries.json not found in database/ directory. "
            "Please ensure the file exists."
        )
    
    
    def load(self) -> List[Dict[str, Any]]:
        try:
            with open(self.json_path, 'r', encoding='utf-8') as file:
                data = json.load(file)
            
            self._queries = data.get('queries', [])
            self._validate_queries()
            self._convert_types()
            return self._queries
            
        except FileNotFoundError:
            raise FileNotFoundError(f"Queries file not found: {self.json_path}")
        except json.JSONDecodeError as e:
            raise ValueError(f"Invalid JSON in queries file: {str(e)}")
    
    
    def _validate_queries(self):
        required_fields = {'name', 'query'}
        
        for i, query in enumerate(self._queries):
            missing = required_fields - set(query.keys())
            if missing:
                raise ValueError(
                    f"Query {i + 1} is missing required fields: {missing}"
                )
            
            if not isinstance(query['name'], str):
                raise ValueError(
                    f"Query {i + 1}: 'name' must be a string"
                )
            if not isinstance(query['query'], str):
                raise ValueError(
                    f"Query {i + 1}: 'query' must be a string"
                )
    
    
    def _convert_types(self):
        for query in self._queries:
            params_type = query.get('params_type')
            
            if params_type == 'int':
                query['params_type'] = int
            elif params_type == 'str':
                query['params_type'] = str
            else:
                query['params_type'] = None
    
    
    def get_queries(self) -> List[Dict[str, Any]]:
        if not self._queries:
            self.load()
        return self._queries
    
    
    def reload(self) -> List[Dict[str, Any]]:
        self._queries = []
        return self.load()
    
    
    def get_query_by_name(self, name: str) -> Optional[Dict[str, Any]]:
        for query in self.get_queries():
            if query['name'] == name:
                return query
        return None
    
    
    def get_query_names(self) -> List[str]:
        return [q['name'] for q in self.get_queries()]
    
    
    def get_query_count(self) -> int:
        return len(self.get_queries())
    
