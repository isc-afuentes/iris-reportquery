Class ReportQuery.domain.model.QueryDef Extends (%Persistent, %JSON.Adaptor)
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

Storage Default
{
<Data name="QueryDefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>SqlQuery</Value>
</Value>
<Value name="5">
<Value>QueryParamsDef</Value>
</Value>
</Data>
<DataLocation>^ReportQuery.domai620C.QueryDefD</DataLocation>
<DefaultData>QueryDefDefaultData</DefaultData>
<IdLocation>^ReportQuery.domai620C.QueryDefD</IdLocation>
<IndexLocation>^ReportQuery.domai620C.QueryDefI</IndexLocation>
<StreamLocation>^ReportQuery.domai620C.QueryDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
