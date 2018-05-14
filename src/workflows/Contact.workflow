<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Person_Recordtype_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Adult1_EPDS</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Person Recordtype Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Person Recordtype updating Rule</fullName>
        <actions>
            <name>Person_Recordtype_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.BRI_TGT_Relation__c</field>
            <operation>equals</operation>
            <value>MOB</value>
        </criteriaItems>
        <description>This is used to update the Person record type to Adult1EPDs based on TGT relation field on persons.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
