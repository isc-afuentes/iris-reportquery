Class ReportQuery.domain.model.QueryParamDef Extends (%Persistent, %JSON.Adaptor)
{

Property Name As %String;

Property Description As %String;

Property Type As %String;

/// parent Inbox
Relationship QueryDef As QueryDef(%JSONREFERENCE = "ID") [ Cardinality = one, Inverse = QueryParamsDef ];

Index QueryDefIndex On QueryDef;

Storage Default
{
<Data name="QueryParamDefDefaultData">
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
<Value>Type</Value>
</Value>
<Value name="5">
<Value>QueryDef</Value>
</Value>
</Data>
<DataLocation>^ReportQuery620C.QueryParamDefD</DataLocation>
<DefaultData>QueryParamDefDefaultData</DefaultData>
<IdLocation>^ReportQuery620C.QueryParamDefD</IdLocation>
<IndexLocation>^ReportQuery620C.QueryParamDefI</IndexLocation>
<StreamLocation>^ReportQuery620C.QueryParamDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
