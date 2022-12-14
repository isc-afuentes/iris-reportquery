Import ReportQuery.model

/// Interactor that implements use cases on the model
Class ReportQuery.interactors.QueryI Extends %RegisteredObject
{

/// Create a query definition
Method Create(q As QueryDef) As %String
{
    try {
        new $Roles
        do $system.Security.AddRoles("InteractorPRA")

        $$$ThrowOnError(q.%Save(1))
        return q.%Id()

    } catch ex {
        throw ex
    }
}

/// Update a query definition
Method Update(q As QueryDef) As %String
{
    try {
        new $Roles
        do $system.Security.AddRoles("InteractorPRA")

        $$$ThrowOnError(q.%Save())
        return q.%Id()

    } catch ex {
        throw ex
    }
}

/// Get a query definition by id
Method GetById(id As %String) As QueryDef
{
    try {
        new $Roles
        do $system.Security.AddRoles("InteractorPRA")

        set q = ##class(QueryDef).%OpenId(id)
        if '$isobject(q) throw ##class(%Exception.General).%New("QueryDef does not exist","","",id)
        return q
    } catch ex {
        throw ex
    }
}

/// Execute a query using a $list as parameter
Method ExecuteQueryFromList(qId As %String, argsList As %List) As %SQL.StatementResult
{
    kill args
    for i=1:1:$listlength(argsList) {
        set args(i) = $listget(argsList, i)
    }
    set args=i
    return ..ExecuteQueryFromArray(qId, .args)
}

/// Execute a query using an array as parameter
/// e.g. set args=2, args(1)="M", args(2)="99"
Method ExecuteQueryFromArray(qId As %String, ByRef args) As %SQL.StatementResult
{
    try {
        #dim queryDef As QueryDef = ..GetById(qId)
        
        // validate args
        if (args'=queryDef.QueryParamsDef.Count()) throw ##class(%Exception.General).%New("Invalid args","","",qId)

        set statement = ##class(%SQL.Statement).%New()
        set status = statement.%Prepare(queryDef.SqlQuery)
        if '$$$ISOK(status) throw ##class(%Exception.General).%New("Error preparing SQL","","",qId)
        
        set resultSet = statement.%Execute(args...)
        return resultSet

    } catch ex {
        throw ex
    }
}

/// Export a resultset to a XLS file
Method ExportToXLS(resultSet As %SQL.StatementResult, fileName As %String) [ Language = python ]
{
    from openpyxl import Workbook
    from openpyxl.utils.dataframe import dataframe_to_rows
    
    wb = Workbook()
    ws = wb.active

    import iris
    pyResultSet = iris.cls('%SYS.Python.SQLResultSet')._New(resultSet)
    df = pyResultSet.dataframe()
    
    for r in dataframe_to_rows(df, index=True, header=True):
        ws.append(r)
    
    for cell in ws['A'] + ws[1]:
        cell.style = 'Pandas'
    
    wb.save(fileName)
}

/// Class query to return all query definitions
Query GetQueries(name As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,Description:%String,SQLQueryText:%String") [ SqlProc ]
{
    SELECT ID,Name,Description,SQLQuery FROM QueryDef
    WHERE (Name %STARTSWITH :name)
    ORDER BY Name
}

}
