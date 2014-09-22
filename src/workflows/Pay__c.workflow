<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Payment_Credit</fullName>
        <field>Credit_User__c</field>
        <formula>if(
and(
not(isblank( Collection__r.Last_PtP_Creator__c )), 
not(isblank( Collection__r.Last_Promise_Start__c )),
not(isblank( Collection__r.Last_Promise_End__c )),
Transaction_Date__c  &gt;  Collection__r.Last_Promise_Start__c -1,
Transaction_Date__c  &lt;  Collection__r.Last_Promise_End__c +4),
Collection__r.Last_PtP_Creator__c, Collection__r.Owner:User.FirstName+&quot; &quot;+ Collection__r.Owner:User.LastName)</formula>
        <name>Populate Payment Credit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Credit on Payments Received</fullName>
        <actions>
            <name>Populate_Payment_Credit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
