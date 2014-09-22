<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Clear_Call_Back_Time</fullName>
        <field>Call_Back_Time__c</field>
        <name>Clear Call Back Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disposition_Manager_Review</fullName>
        <field>Disposition__c</field>
        <literalValue>Manager Review</literalValue>
        <name>Disposition Manager Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disposition_Promise_to_Pay</fullName>
        <field>Disposition__c</field>
        <literalValue>Promise to Pay</literalValue>
        <name>Disposition Promise to Pay</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disposition_Skip</fullName>
        <field>Disposition__c</field>
        <literalValue>Skiptrace</literalValue>
        <name>Disposition Skip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disposition_Working</fullName>
        <field>Disposition__c</field>
        <literalValue>Working</literalValue>
        <name>Disposition Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Back_Time</fullName>
        <field>Call_Back_Time__c</field>
        <formula>Call_Back_Time__c</formula>
        <name>Update Call Back Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Action_Field</fullName>
        <field>Last_Action__c</field>
        <formula>text(Action__c)</formula>
        <name>Update Last Action Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Remove tickler after action taken</fullName>
        <actions>
            <name>Clear_Call_Back_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Call_Back_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Disposition__c</field>
            <operation>notEqual</operation>
            <value>Promise to Pay,Paid In Full,Settled in Full,*Bankruptcy,*Cease and Desist,*Company Concedes,*Deceased,*Do Not Call,*Fraud,*Legal,*Manager Review,*Sold at Auction</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Collection Action</fullName>
        <actions>
            <name>Update_Call_Back_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Collection_Action__c.Call_Back_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Disposition to Loan Review</fullName>
        <actions>
            <name>Disposition_Manager_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Collection_Action__c.Action__c</field>
            <operation>equals</operation>
            <value>Loan Review</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Disposition to Skip</fullName>
        <actions>
            <name>Disposition_Skip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Collection_Action__c.Action__c</field>
            <operation>equals</operation>
            <value>Skip</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Disposition to Working</fullName>
        <actions>
            <name>Disposition_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Collection_Action__c.Action__c</field>
            <operation>equals</operation>
            <value>Called - Bad number,Called - Left Mesg,Called - No contact,Contact - RPC,Contact – Non RPC,Contact - RPC - Call back,Incoming Call –RPC,Incoming Call – Non RPC,Loan Review</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Last Action</fullName>
        <actions>
            <name>Update_Last_Action_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Collection_Action__c.Action__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
