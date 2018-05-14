<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>display fields based on ASQ SE picklist values</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Assessment__c.BRI_ASQ_SE__c</field>
            <operation>equals</operation>
            <value>6 months</value>
        </criteriaItems>
        <description>based on ASQ Se picklist values the fields are displayed on page</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
