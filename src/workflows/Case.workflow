<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Disposition_to_Working</fullName>
        <field>Disposition__c</field>
        <literalValue>Working</literalValue>
        <name>Disposition to Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Searchable_Name</fullName>
        <field>Searchable_Name__c</field>
        <formula>Account.FirstName &amp;&quot; &quot;&amp; Account.LastName</formula>
        <name>Searchable Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Complete</fullName>
        <field>Status</field>
        <literalValue>Complete</literalValue>
        <name>Status Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_New</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Status New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Settlement_Agreed</fullName>
        <field>Status</field>
        <literalValue>Settlement Agreed</literalValue>
        <name>Status Settlement Agreed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_in_Process</fullName>
        <field>Status</field>
        <literalValue>In Process</literalValue>
        <name>Status in Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change Disposition Working from PTP</fullName>
        <actions>
            <name>Disposition_to_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>and(Active_Promises__c=0,ispickval(Disposition__c,&quot;Promise to Pay&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Status to Complete</fullName>
        <actions>
            <name>Status_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Disposition__c</field>
            <operation>equals</operation>
            <value>Paid In Full,*Cease and Desist,*Deceased,*Do Not Call,*Fraud,*Legal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Email to Case</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Status to In Process</fullName>
        <actions>
            <name>Status_in_Process</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Disposition__c</field>
            <operation>equals</operation>
            <value>Working,Skiptrace,Manager Review,Broken Promise,Rework</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>In Process</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Status to New</fullName>
        <actions>
            <name>Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 3) AND 2 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Disposition__c</field>
            <operation>equals</operation>
            <value>Ready to Collect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Disposition__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Email to Case</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Status to Settlement Agreed</fullName>
        <actions>
            <name>Status_Settlement_Agreed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Disposition__c</field>
            <operation>equals</operation>
            <value>Promise to Pay</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Settlement Agreed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Searchable Name</fullName>
        <actions>
            <name>Searchable_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
