/// Query definition
Class ReportQuery.model.QueryDef Extends (%Persistent, %JSON.Adaptor)
{

Property Id As %String(%JSONINCLUDE = "OUTPUTONLY") [ Calculated ];

Property Name As %String;

Property Description As %String;

Property SqlQuery As %String(MAXLEN = "");

Relationship QueryParamsDef As QueryParamDef [ Cardinality = many, Inverse = QueryDef ];

/// Id Getter 
Method IdGet() As %String
{
	quit ..%Id()
}

/// This callback method is invoked by the <METHOD>%Open</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being opened.
/// 
/// <P>If this method returns an error then the object will not be opened.
Method %OnOpen() As %Status [ Private, ServerOnly = 1 ]
{
	quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	if $Roles'["InteractorRole" quit $$$ERROR($$$GeneralError, "No InteractorRole")
	quit $$$OK
}

}
