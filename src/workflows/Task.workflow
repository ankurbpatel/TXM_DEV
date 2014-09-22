<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Closed_Time</fullName>
        <field>Closed_Time__c</field>
        <formula>now()</formula>
        <name>Closed Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dudate_Field_Update</fullName>
        <field>Due__c</field>
        <formula>NOW()</formula>
        <name>Dudate Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Due_Date_Now</fullName>
        <field>Due__c</field>
        <formula>now()</formula>
        <name>Due Date Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetStatusToInprocess</fullName>
        <field>Lead_Opportunity_Status__c</field>
        <formula>&apos;In Process&apos;</formula>
        <name>SetStatusToInprocess</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_to_closed</fullName>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Set status to closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_field_to_Now</fullName>
        <field>Due__c</field>
        <formula>NOW()</formula>
        <name>Update Due field to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Add Due Date</fullName>
        <actions>
            <name>Due_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Due__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Closed Time</fullName>
        <actions>
            <name>Closed_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( IsClosed =true, ISBLANK(Closed_Time__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Detail Updated on Call Planning Task</fullName>
        <actions>
            <name>Set_status_to_closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISPICKVAL(Detail__c,&quot;&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Follow up call attempt needed max observed</fullName>
        <actions>
            <name>Follow_up_Attempt</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Detail__c</field>
            <operation>equals</operation>
            <value>Busy,No Answer,Not in Service / Disconnected,Voicemail,Voicemail Not Set Up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Attempt__c</field>
            <operation>lessThan</operation>
            <value>8</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Follow up call attempt needed no max</fullName>
        <actions>
            <name>Follow_up_Attempt</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Task.Detail__c</field>
            <operation>equals</operation>
            <value>Call Back</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Detail__c</field>
            <operation>equals</operation>
            <value>Message with 3rd Party</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Attempt__c</field>
            <operation>lessThan</operation>
            <value>8</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Insert Due Date</fullName>
        <actions>
            <name>Dudate_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SetStatusToInprocess</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Is_Re_Opened__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Follow_up_Attempt</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Task.ActivityDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow-up Attempt</subject>
    </tasks>
</Workflow>
