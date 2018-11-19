# API V1

## GET: api/v1/find_ubs

##### Request
| Param   |      Example      |  Description |
|----------|:-------------:|------:|
| query |  -23.604936,-46.692999 | Lat/Log para pesquisa |
| page |    2   |   Página atual |
| per_page | 10 |  Itens por página (default: 10) |
  
[http://localhost:3000/api/v1/find_ubs?query=-23.604936,-46.692999&page=1&per_page=1](http://localhost:3000/api/v1/find_ubs?query=-23.604936,-46.692999&page=1&per_page=1)

##### Response
```json
{
  "current_page": 1,
  "per_page": 1,
  "total_entries": 37690,
  "entries": [
    {
      "id": 39860,
      "name": "UBS REAL PQ PAULO MANGABEIRA ALBERNAZ FILHO",
      "address": "RUA BARAO MELGACO",
      "city": "São Paulo",
      "phone": "1137582329",
      "geocode": {
        "lat": -23.6099946498864,
        "long": -46.7057347297655
      },
      "scores": {
        "size": 3,
        "adaptation_for_seniors": 3,
        "medical_equipment": 1,
        "medicine": 3
      } 
    }
  ]
}
````