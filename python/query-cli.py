import irisnative
import iris
import configparser
import argparse
import time
import json

def main():
    """query cli
    
    Examples:
    
    Display info about all queries:
    cli.py --info
    
    Display info about a given query:
    cli.py --info -q 2
    
    Run a query:
    cli.py --run -q 2 -args M
    
    """
    import argparse
    parser = argparse.ArgumentParser(description="Report query CLI. Display info and run Report Queries")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("-i", "--info", action="store_true")
    group.add_argument("-r", "--run", action="store_true")
    parser.add_argument('-q', '--queryid')
    parser.add_argument('-a','--args', nargs='+', help='<Required> Set flag')
    args = parser.parse_args()
    
    # info: display queries
    if args.info:
        if args.queryid:
            show_query_by_id(args.queryid)
        else:
            show_all_queries()
    
    # execute query
    elif args.run:
        if (args.queryid is None):
            parser.error("--run requires --queryid")
        run_query(args.queryid, args.args)
        

def show_query_by_id(identifier):
    """Show an specific query (id)
    Display query information given its identifier
    """
    
    conn = create_connection()
    irispy = create_iris(conn)
    
    service = irispy.classMethodObject("ReportQuery.domain.ports.Service","%New")
    queryDef = service.invoke("GetById", identifier)
    jsonQueryDef = iris.IRISReference(None); 
    queryDef.invoke("%JSONExportToString", jsonQueryDef)
    parsed = json.loads(jsonQueryDef.getValue())
    print(json.dumps(parsed, indent=2))
    
    conn.close()
    

def show_all_queries():
    """Show all queries
    Display all existing queries 
    """
        
    conn = create_connection()
    irispy = create_iris(conn)
    
    statement = irispy.classMethodObject("%SQL.Statement","%New")
    status = statement.invoke("%PrepareClassQuery", "ReportQuery.domain.ports.Service", "GetQueries")
    rs = statement.invoke("%Execute", "")
    
    while rs.invoke("%Next"):
        id = rs.invokeInteger("%Get", "ID")
        name = rs.invoke("%Get", "Name")
        row = { "Id": id, "Name": name}
        print(json.dumps(row))
    
    conn.close()


def run_query(id, args):
    """Run a query

    Args:
        id (_int_): query id
        args (_list_): list of arguments
    """
    # parse query args
    argList = iris.IRISList()
    for arg in args:
        argList.add(arg)
    
    conn = create_connection()
    irispy = create_iris(conn)
    
    service = irispy.classMethodObject("ReportQuery.domain.ports.Service","%New")
    rs = service.invoke("ExecuteQueryFromList", id, argList)
    rs.invokeVoid("%Display")
    
    conn.close()
    

def create_connection():
    """Return an IRIS connection
    """
    
    config = configparser.ConfigParser()
    config.read('config.ini')
    
    ip = config['iris']['ip']
    port = int(config['iris']['port'])
    namespace = config['iris']['namespace']
    username = config['iris']['username']
    password = config['iris']['password']

    # create database connection and IRIS instance
    return irisnative.createConnection(ip,port,namespace,username,password)


def create_iris(connection):
    """Return an irisnative instance
    """
    
    return irisnative.createIris(connection)


if __name__ == "__main__":
    main()