Report Query

# Quick start

## Build & run:
```
docker-compose build
docker-compose up -d
```

## REST client
* Open [ReportQueryAPI.postman_collection.json](ReportQueryAPI.postman_collection.json) in Postman
* Test


## Command Line (CLI)

Create a virtual env:
```
cd python
python3 -m venv env
source env/bin/activate
```

Install dependencies:
```
pip3 install irisnative/intersystems_irispython-3.2.0-py3-none-any.whl
pip3 install configparser
```

Display info about all queries:
```
python query-cli.py --info
```

Display info about a given query:
```
cli.py --info -q 2
```
   
Run a query:
```
cli.py --run -q 2 -args M
```
