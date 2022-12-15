Import ReportQuery.model

/// 
/// Simple use cases tests
Class ReportQuery.test.Simple
{

/// Test an Interactor
ClassMethod TestInteractor()
{
    set service = ##class(ReportQuery.interactors.QueryI).%New()
    set queryDef = ##class(QueryDef).%New()
    set queryDef.Name = "List of persons by name"
    set queryDef.SqlQuery = "SELECT * FROM ReportQuery_test_data.Person"
    set id = service.Create(queryDef)
}

/// Returns an error because you cannot use %Open, %Save directly without using an Interactor
ClassMethod TestNoInteractor()
{
    set queryDef = ##class(ReportQuery.model.QueryDef).%OpenId(1)
    set queryDef.Description = "mod-no-interactor"
    write queryDef.%Save()
}

/// Create some queries
ClassMethod TestCreateQueries()
{
    try {
        set service = ##class(ReportQuery.interactors.QueryI).%New()

        set queryDef = ##class(QueryDef).%New()
        set queryDef.Name = "List of persons by name"
        set queryDef.SqlQuery = "SELECT * FROM ReportQuery_test_data.Person"
        set id = service.Create(queryDef)
        write !,"Created Query: ",id
 
        set queryDef = ##class(QueryDef).%New()
        set queryDef.Name = "Persons starting by arg"
        set queryDef.SqlQuery = "SELECT * FROM ReportQuery_test_data.Person where FirstName %StartsWith ?"
        set queryParam = ##class(QueryParamDef).%New()
        set queryParam.Name = "Firstname startswith"
        set queryParam.Type = "string"
        
        do queryDef.QueryParamsDef.Insert(queryParam)
        set id = service.Create(queryDef)
        write !,"Created Query: ",id

    } catch ex {
        set sc = ex.AsStatus()
        do $system.Status.DisplayError(sc)
    }
}

/// Create a run a simple query
ClassMethod TestQuerySimple()
{
    try {
        set service = ##class(ReportQuery.interactors.QueryI).%New()

        set queryDef = ##class(QueryDef).%New()
        set queryDef.Name = "List of persons by name"
        set queryDef.SqlQuery = "SELECT * FROM ReportQuery_test_data.Person"

        set id = service.Create(queryDef)
        write !,"Created QueryDef Id=",id

        kill args
        set args=0
        set rs = service.ExecuteQueryFromArray(id, .args)

        do service.ExportToXLS(rs, "/app/query-simple.xlsx")

    } catch ex {
        set sc = ex.AsStatus()
        do $system.Status.DisplayError(sc)
    }
}

/// Create and run a query using args
ClassMethod TestQueryArgs()
{
    try {
        set service = ##class(ReportQuery.interactors.QueryI).%New()

        set queryDef = ##class(QueryDef).%New()
        set queryDef.Name = "Persons starting by arg"
        set queryDef.SqlQuery = "SELECT * FROM ReportQuery_test_data.Person where FirstName %StartsWith ?"
        
        set queryParam = ##class(QueryParamDef).%New()
        set queryParam.Name = "Firstname startswith"
        set queryParam.Type = "string"
        
        do queryDef.QueryParamsDef.Insert(queryParam)

        set id = service.Create(queryDef)
        write !,"Created QueryDef Id=",id

        kill args
        set args=1, args(1)="M"
        set rs = service.ExecuteQueryFromArray(id, .args)

        do service.ExportToXLS(rs, "/app/query-args.xlsx")

    } catch ex {
        set sc = ex.AsStatus()
        do $system.Status.DisplayError(sc)
    }
}

}
