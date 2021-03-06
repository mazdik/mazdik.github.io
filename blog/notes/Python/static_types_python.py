from typing import Dict, List, Tuple, Optional, Union

name_counts: Dict[str, int] = {
    "Adam": 10,
    "Guido": 12
}

numbers: List[int] = [1, 2, 3, 4, 5, 6, 7]

list_of_dicts: List[Dict[str, int]] = [
    {"key1": 1},
    {"key2": 2}
]

my_data: Tuple[str, int, float] = ("Adam", 10, 5.7)

LatLngVector = List[Tuple[float, float]]
points: LatLngVector = [
    (25.91375, -60.15503),
    (-11.01983, -166,484877),
    (-11.01983, -166.48477)
]

my_string: str = "My String Value"

def function_name(arg1: type, arg2: type) -> teturn_type:

def get_some_date(some_argument: int=None) -> Optional[datetime]:

def get_some_date(some_argument: int=None) -> Union[datetime, None]:


List[str] # [] || ['text']

List[Optional[str]] # [] || ['text'] || [None]

Optional[List[Optional[str]]] # [] || ['text'] || [None] || None

list # List[Any]

# Static type checker: https://github.com/microsoft/pyright
