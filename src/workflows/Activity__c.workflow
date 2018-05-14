<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Home_Visit_Number</fullName>
        <description>Auto generate Home Visit number per household</description>
        <field>BRI_HomeVisit_Number__c</field>
        <formula>&apos;HM00&apos;+&apos;BRI_Household__r.BRI_Home_Visit_Count__c&apos;</formula>
        <name>Home Visit Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
