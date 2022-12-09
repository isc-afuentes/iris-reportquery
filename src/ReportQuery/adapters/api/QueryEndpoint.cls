Class ReportQuery.adapters.api.QueryEndpoint Extends %CSP.REST
{

Parameter HandleCorsRequest As %Integer = 1;

XData UrlMap
{
<Routes>
<Route Url="/query" Method="GET" Call="GetAllQueries"/>
<Route Url="/query/:id" Method="GET" Call="GetQueryById"/>
<Route Url="/query/:id/toxls" Method="GET" Call="ExecuteOutputXls"/>
</Routes>
}

/// Common config
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
    set %response.ContentType = "application/json"
    Quit $$$OK
}

/// Display info about all queries
ClassMethod GetAllQueries() As %Status
{
    set ret = $$$OK
    try {
        set statement = ##class(%SQL.Statement).%New()
        set sc = statement.%PrepareClassQuery("ReportQuery.domain.ports.Service","GetQueries")
        $$$ThrowOnError(sc)
        set rs = statement.%Execute("")
        
        set array = []
        while rs.%Next() {
            do array.%Push({
                    "Id": (rs.%Get("ID")),
                    "Name": (rs.%Get("Name")),
                    "Description": (rs.%Get("Description"))
                })
        }
        
        set %response.Status = "200"
        write array.%ToJSON()

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

/// Return info of a given query (id)
ClassMethod GetQueryById(id As %String) As %Status
{
    set ret = $$$OK
    try {
        set service = ##class(ReportQuery.domain.ports.Service).%New()
        set query = service.GetById(id)
        set %response.Status = "200"
        do query.%JSONExport()

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

/// Execute query and output to xlsx format
ClassMethod ExecuteOutputXls(id As %String) As %Status
{
    set ret = $$$OK
    try {
        // initialize query args (empty
        kill args
        set args=0

        // parse request params into actual query args
        if $data(%request.Data) = 10 { // %request.Data is defined and has descendants
            set requestParam="",i=0
            for {
                set requestParam = $order(%request.Data(requestParam))
                quit:requestParam=""
                set i = i + 1
                set args(i) = %request.Data(requestParam,1)
            }
            set args = i
        }
        
        // execute query
        set service = ##class(ReportQuery.domain.ports.Service).%New()
        set rs = service.ExecuteQueryFromArray(id, .args)

        // export to xlsx
        set xlsFileName = "/app/"_$job_".xlsx"
        do service.ExportToXLS(rs, xlsFileName)

        // return file as response
        set %response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        do %response.SetHeader("Content-Disposition","attachment;filename=""query.xlsx""")
        set stream=##class(%Stream.FileBinary).%New()
        set sc=stream.LinkToFile(xlsFileName)
        do stream.OutputToDevice()

        // delete temporary file
        do ##class(%File).Delete(xlsFileName)

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

}
