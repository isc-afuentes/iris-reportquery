/// Query Parameter definition
Class ReportQuery.model.QueryParamDef Extends (%Persistent, %JSON.Adaptor)
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
<DataLocation>^ReportQuery1C53.QueryParamDefD</DataLocation>
<DefaultData>QueryParamDefDefaultData</DefaultData>
<IdLocation>^ReportQuery1C53.QueryParamDefD</IdLocation>
<IndexLocation>^ReportQuery1C53.QueryParamDefI</IndexLocation>
<StreamLocation>^ReportQuery1C53.QueryParamDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
