<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Assessment_Status_Update</fullName>
        <field>BRI_Screen_Status__c</field>
        <literalValue>Positive</literalValue>
        <name>Assessment Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assigning_To_County_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Site_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assigning To County Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPCS_Status_Update</fullName>
        <field>BRI_Screen_Status__c</field>
        <literalValue>Positive</literalValue>
        <name>CPCS Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Navigate_to_Parent_Survey</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Parent_Survey</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Navigate to Parent Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Screen_Assessment_Status_Update</fullName>
        <field>BRI_Screen_Status__c</field>
        <literalValue>Positive</literalValue>
        <name>Screen Assessment Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Result_Field_Update</fullName>
        <field>BRI_Survey_Result__c</field>
        <literalValue>Positive</literalValue>
        <name>Survey Result Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Created_to_true</fullName>
        <field>Survey_Created__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Created to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updatin_Survey_Result_by_score</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Parent_Survey</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Updatin Survey Result by score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Survey_Result_by_score</fullName>
        <field>BRI_Survey_Result__c</field>
        <literalValue>Positive</literalValue>
        <name>Updating Survey Result by score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Survey_Result_by_scores</fullName>
        <field>BRI_Survey_Result__c</field>
        <literalValue>Positive</literalValue>
        <name>Updating Survey Result by scores</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CPCS Assessment Status Update</fullName>
        <actions>
            <name>CPCS_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>Intake__c.Any_Open_OnGoing_Case_with_DCS__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Intake__c.Referred_By__c</field>
            <operation>equals</operation>
            <value>Community Resource,Self Refer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Intake__c.Healthy_Families_Participation__c</field>
            <operation>equals</operation>
            <value>Healthy Family is at capacity,Not Eligible</value>
        </criteriaItems>
        <criteriaItems>
            <field>Intake__c.Juven_Prob_Dep_has_open_case_on_child__c</field>
            <operation>equals</operation>
            <value>&quot;Yes, Child is Placed Outside of the Home, There are other Children in Home&quot;</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IntakeRecordAssigningToQueue</fullName>
        <actions>
            <name>Assigning_To_County_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Intake__c.County__c</field>
            <operation>equals</operation>
            <value>Marion</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Referral%2F Screen Navigate to Parent Survey</fullName>
        <actions>
            <name>Navigate_to_Parent_Survey</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Intake__c.BRI_Screen_Status__c</field>
            <operation>equals</operation>
            <value>Positive</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Screen Assessment Rule</fullName>
        <actions>
            <name>Screen_Assessment_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF((ISPICKVAL( Single__c , &apos;Yes&apos;)) || (ISPICKVAL( Inadequate_Income__c , &apos;Yes&apos;)) || (ISPICKVAL( Primary_Income_is_SSDI__c , &apos;Yes&apos;)), true,    IF((ISPICKVAL( Education_under_12_years__c , &apos;Yes&apos;)) &amp;&amp; (ISPICKVAL( History_of_Current_Substance_abuse__c , &apos;Yes&apos;)), true,  IF((ISPICKVAL( Education_under_12_years__c , &apos;Yes&apos;)) &amp;&amp; (ISPICKVAL( History_of_Current_Psychiatric_abuse__c , &apos;yes&apos;)), true, IF((ISPICKVAL( Education_under_12_years__c , &apos;Yes&apos;)) &amp;&amp; (ISPICKVAL( Marital_or_Family_Problems__c , &apos;yes&apos;)), true, IF((ISPICKVAL( Education_under_12_years__c , &apos;yes&apos;)) &amp;&amp; (ISPICKVAL( Unstable_Housing__c , &apos;Yes&apos;)), true, IF((ISPICKVAL( History_of_Current_Substance_abuse__c , &apos;yes&apos;)) &amp;&amp; (ISPICKVAL( History_of_Current_Psychiatric_abuse__c , &apos;Yes&apos;)), true,  IF((ISPICKVAL( History_of_Current_Substance_abuse__c , &apos;Yes&apos;)) &amp;&amp; (ISPICKVAL( Marital_or_Family_Problems__c , &apos;Yes&apos;)), true, IF((ISPICKVAL( History_of_Current_Substance_abuse__c , &apos;Yes&apos;)) &amp;&amp; (ISPICKVAL( Unstable_Housing__c , &apos;Yes&apos;)), true, IF((ISPICKVAL( History_of_Current_Psychiatric_abuse__c , &apos;Yes&apos;)) &amp;&amp; (ISPICKVAL( Marital_or_Family_Problems__c , &apos;Yes&apos;)), true, IF((ISPICKVAL( History_of_Current_Psychiatric_abuse__c , &apos;Yes&apos;)) &amp;&amp; (ISPICKVAL( Unstable_Housing__c , &apos;Yes&apos;)), true, IF((ISPICKVAL( Marital_or_Family_Problems__c , &apos;Yes&apos;)) &amp;&amp; (ISPICKVAL( Unstable_Housing__c , &apos;Yes&apos;)), true, false )))))))))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Survey Result Update Rule</fullName>
        <actions>
            <name>Survey_Result_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Intake__c.BRI_Clinical_Override__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update survey created</fullName>
        <actions>
            <name>Update_Survey_Created_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Intake__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Survey Questions</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>updatin survey result by test score values</fullName>
        <actions>
            <name>Updating_Survey_Result_by_scores</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>VALUE(TEXT(BRI_Parent_s_Childhood_Experience__c )) + VALUE( TEXT( BRI_Lifestyle_Behavior_and_Mental_Health__c  ))  +VALUE(TEXT(  BRI_Parenting_Experience__c) ) +VALUE(  TEXT( BRI_4_Coping_Skills_and_Support_System__c) ) &gt;=  25</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>updating survey result by test scores</fullName>
        <actions>
            <name>Updating_Survey_Result_by_scores</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Intake__c.Total_Score__c</field>
            <operation>greaterOrEqual</operation>
            <value>25</value>
        </criteriaItems>
        <description>if test score is greater than equals to 25 then its positive else negative</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
