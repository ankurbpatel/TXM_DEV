<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Lead_Account_Ambiguous_Name</fullName>
        <field>Name</field>
        <formula>IF(Account__r.Name!=&apos;&apos;, Account__r.Name, Account__r.FirstName +&apos; &apos;+ Account__r.LastName)</formula>
        <name>Update Lead Account Ambiguous Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change Lead Account Ambiguous Match Name</fullName>
        <actions>
            <name>Update_Lead_Account_Ambiguous_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead_Account_Ambiguous_Match__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>Changes Name for Lead Account Ambiguous Match</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
