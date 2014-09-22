<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lead_Exception_Queue_Alert</fullName>
        <description>Lead Exception Queue Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>TMX_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>tina.wilburn@titlemax.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_in_Exception_Queeu</template>
    </alerts>
    <alerts>
        <fullName>New_Lead_Notification</fullName>
        <description>New Lead Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce_contact@titlemax.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Other/LeadsNewassignmentnotification</template>
    </alerts>
    <alerts>
        <fullName>Send_IL_Appt_Email</fullName>
        <description>Send IL Appt Email</description>
        <protected>false</protected>
        <recipients>
            <field>Store_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Center/InstaLoan_Manual_Appt_Set_VF</template>
    </alerts>
    <alerts>
        <fullName>Send_TitleMax_Appt_Email</fullName>
        <description>Send TitleMax Appt Email</description>
        <protected>false</protected>
        <recipients>
            <field>Store_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Center/TM_Automated_Appointment_Set</template>
    </alerts>
    <alerts>
        <fullName>TitleBucks_Email_Appointment_Set</fullName>
        <description>TitleBucks Email Appointment Set</description>
        <protected>false</protected>
        <recipients>
            <field>Store_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Center/TB_Automated_Appointment_Set</template>
    </alerts>
    <fieldUpdates>
        <fullName>Brand_TitleBucks</fullName>
        <field>Brand_Requested__c</field>
        <literalValue>TitleBucks</literalValue>
        <name>Brand TitleBucks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Brand_TitleMax</fullName>
        <field>Brand_Requested__c</field>
        <literalValue>TitleMax</literalValue>
        <name>Brand TitleMax</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Lead_for_NC_to_Border</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Lead for NC to Border</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Exclude_from_Bonus_True</fullName>
        <field>Exclude_From_Bonus__c</field>
        <literalValue>1</literalValue>
        <name>Exclude from Bonus - True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUForPermanentLeadClosed</fullName>
        <field>RecordTypeId</field>
        <lookupValue>RecordTypeForPermanentLeadClosed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FUForPermanentLeadClosed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_Reassign_Lead</fullName>
        <field>Reassigned_Lead__c</field>
        <literalValue>1</literalValue>
        <name>Flag Reassign Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InstaLoan</fullName>
        <field>Brand_Requested__c</field>
        <literalValue>InstaLoan</literalValue>
        <name>InstaLoan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LeadStatus</fullName>
        <field>LeadStatus__c</field>
        <formula>TEXT(Status)</formula>
        <name>LeadStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Assigned</fullName>
        <field>Lead_Assigned__c</field>
        <literalValue>0</literalValue>
        <name>Lead Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Assigned_Flag</fullName>
        <field>Lead_Assigned__c</field>
        <literalValue>0</literalValue>
        <name>Lead Assigned Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Channel_Web</fullName>
        <field>Lead_Channel__c</field>
        <literalValue>Web</literalValue>
        <name>Lead Channel Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Contacted</fullName>
        <field>Contacted__c</field>
        <literalValue>1</literalValue>
        <name>Lead Contacted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Exclude_from_Bonus_False</fullName>
        <field>Exclude_From_Bonus__c</field>
        <literalValue>0</literalValue>
        <name>Lead Exclude from Bonus - False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Qualified</fullName>
        <field>Qualified__c</field>
        <literalValue>1</literalValue>
        <name>Lead Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_to_NC_to_Border_State_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>NC_to_Border_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Move to NC to Border State Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Overnight_Lead</fullName>
        <field>Overnight_Lead__c</field>
        <literalValue>1</literalValue>
        <name>Overnight Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Assigned_Time</fullName>
        <field>Owner_Assigned_Time__c</field>
        <formula>now()</formula>
        <name>Owner Assigned Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Store_Email_Field</fullName>
        <field>Store_Email__c</field>
        <formula>Store_Name__r.Email_Address__c</formula>
        <name>Populate Store Email Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_store_id</fullName>
        <field>Store_ID__c</field>
        <formula>Store_Name__r.Id</formula>
        <name>Populate store id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Requested_1st_Lien</fullName>
        <field>Product_Requested__c</field>
        <literalValue>1st Lien Loan</literalValue>
        <name>Product Requested 1st Lien</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Requested_2nd_Lien</fullName>
        <field>Product_Requested__c</field>
        <literalValue>2nd Lien Loan</literalValue>
        <name>Product Requested 2nd Lien</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Requested_Bad_Credit</fullName>
        <field>Product_Requested__c</field>
        <literalValue>Bad Credit</literalValue>
        <name>Product Requested Bad Credit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Requested_Personal</fullName>
        <field>Product_Requested__c</field>
        <literalValue>Personal Loan</literalValue>
        <name>Product Requested Personal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Requested_Signature</fullName>
        <field>Product_Requested__c</field>
        <literalValue>Signature Loan</literalValue>
        <name>Product Requested Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Requested_Title</fullName>
        <field>Product_Requested__c</field>
        <literalValue>Title</literalValue>
        <name>Product Requested Title</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Overnight</fullName>
        <field>SA_Overnight__c</field>
        <literalValue>1</literalValue>
        <name>SA Overnight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetRecordTypeToClosed</fullName>
        <field>RecordTypeId</field>
        <lookupValue>OSR_Lead_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SetRecordTypeToClosed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetRecordtypeToOSR</fullName>
        <field>RecordTypeId</field>
        <lookupValue>OSR_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SetRecordtypeToOSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Bypass_Assignment_Flag</fullName>
        <field>Bypass_Assignment__c</field>
        <literalValue>1</literalValue>
        <name>Set Bypass Assignment Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reassign_Flag</fullName>
        <field>Reassigned_Lead__c</field>
        <literalValue>1</literalValue>
        <name>Set Reassign Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stamp_date_on_Reassigned_to_Recovery</fullName>
        <field>Reassigned_to_Recovery__c</field>
        <formula>now()</formula>
        <name>Stamp date on Reassigned to Recovery</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_Zone_Rest_CST</fullName>
        <field>Time_Zone_Hour_Restricted__c</field>
        <literalValue>1</literalValue>
        <name>Time Zone Rest - CST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_Zone_Rest_EST</fullName>
        <field>Time_Zone_Hour_Restricted__c</field>
        <literalValue>1</literalValue>
        <name>Time Zone Rest - EST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_Zone_Rest_MST</fullName>
        <field>Time_Zone_Hour_Restricted__c</field>
        <literalValue>1</literalValue>
        <name>Time Zone Rest - MST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_Zone_Rest_PST</fullName>
        <field>Time_Zone_Hour_Restricted__c</field>
        <literalValue>1</literalValue>
        <name>Time Zone Rest - PST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Sent</fullName>
        <field>Appointment_Email_Sent__c</field>
        <formula>now()</formula>
        <name>Update Email Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>OSR_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Lead Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Make_Picklist</fullName>
        <field>Vehicle_Make__c</field>
        <formula>Text(Vehicle_Make_BB__c)</formula>
        <name>Update Make Picklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Model_Picklist</fullName>
        <field>Vehicle_Model__c</field>
        <formula>Text(Vehicle_Model_BB__c)</formula>
        <name>Update Model Picklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Recovery_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Recovery_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Recovery Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Vehicle_Year</fullName>
        <field>Vehicle_Year__c</field>
        <formula>Text(Vehicle_Year_BB__c)</formula>
        <name>Update Vehicle Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ValidLeadForCapacity</fullName>
        <field>ValidLeadForAssignment__c</field>
        <formula>IF(OR(ISPICKVAL(Status,&quot;Closed&quot;),
ISPICKVAL(Status,&quot;Appointment Set&quot;),
ISPICKVAL(Status,&quot;Funded:Confirmed&quot;)), null, 1)</formula>
        <name>ValidLeadForCapacity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Bad Phone Lead</fullName>
        <actions>
            <name>Exclude_from_Bonus_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Last_Disposition__c</field>
            <operation>equals</operation>
            <value>Bad Phone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Exclude_From_Bonus__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Bad Phone Lead - Undo</fullName>
        <actions>
            <name>Lead_Exclude_from_Bonus_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Last_Disposition__c</field>
            <operation>notEqual</operation>
            <value>Bad Phone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Exclude_From_Bonus__c</field>
            <operation>notEqual</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Brand InstaLoan</fullName>
        <actions>
            <name>InstaLoan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>InstaLoan.com</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Brand TitleBucks</fullName>
        <actions>
            <name>Brand_TitleBucks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>TitleBucks.com</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Brand TitleMax</fullName>
        <actions>
            <name>Brand_TitleMax</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>,AutoTitleLoanCenter.com,EasyCashTitleLoans.com,OnTheGoTitleLoans.com,TitleLoansSOS.com,TitleMax.com</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Close Lead NC to Border Store</fullName>
        <actions>
            <name>Close_Lead_for_NC_to_Border</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Move_to_NC_to_Border_State_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Bypass_Assignment_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.PostalCode</field>
            <operation>greaterOrEqual</operation>
            <value>27006</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.PostalCode</field>
            <operation>lessOrEqual</operation>
            <value>28909</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Default Title Prod for TitleBucks</fullName>
        <actions>
            <name>Product_Requested_Title</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISPICKVAL(Brand_Requested__c , &quot;TitleBucks&quot;), ISBLANK(Type_of_Loan__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Exception Queue Notification</fullName>
        <actions>
            <name>Lead_Exception_Queue_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 or ((2 or 3) AND 4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Exception</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>HELP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.First_Contact_Made__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Channel__c</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Is Recovery Lead</fullName>
        <actions>
            <name>Stamp_date_on_Reassigned_to_Recovery</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Owner_to_Recovery_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Lead.Recovery_Due__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Reassigned_to_Recovery__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Recovery_Due__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Last_Detail__c</field>
            <operation>equals</operation>
            <value>Busy,Message with 3rd Party,No Answer,Voicemail,Voicemail Not Set Up</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Channel - Web</fullName>
        <actions>
            <name>Lead_Channel_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Lead.DS_Click_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Referral_URL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Source_URL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Contacted</fullName>
        <actions>
            <name>Lead_Contacted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Contacted__c=FALSE, OR( ISPICKVAL(Last_Disposition__c,&quot;Appointment Not Kept&quot;), ISPICKVAL(Last_Disposition__c,&quot;Contacted&quot;), ISPICKVAL(Last_Disposition__c,&quot;Do Not Call&quot;), ISPICKVAL(Last_Detail__c,&quot;Customer Does Not Qualify&quot;), ISPICKVAL(Last_Detail__c,&quot;Confirmed with Customer&quot;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Product Requested_1st Lien</fullName>
        <actions>
            <name>Product_Requested_1st_Lien</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 4 OR (2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>First</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>Auto Equity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Brand_Requested__c</field>
            <operation>contains</operation>
            <value>InstaLoan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>1st</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Product Requested_2nd Lien</fullName>
        <actions>
            <name>Product_Requested_2nd_Lien</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>2nd</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>second</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Product Requested_Bad Credit</fullName>
        <actions>
            <name>Product_Requested_Bad_Credit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>Bad Credit</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Product Requested_Personal</fullName>
        <actions>
            <name>Product_Requested_Personal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>Pers</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Product Requested_Signature</fullName>
        <actions>
            <name>Product_Requested_Signature</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>Sig</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Product Requested_Title</fullName>
        <actions>
            <name>Product_Requested_Title</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR (2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>Title</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Type_of_Loan__c</field>
            <operation>contains</operation>
            <value>Auto Equity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Brand_Requested__c</field>
            <operation>contains</operation>
            <value>Title</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Qualified</fullName>
        <actions>
            <name>Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(   Qualified__c=FALSE,    OR(     ISPICKVAL(Last_Disposition__c,&quot;Appointment Not kept&quot;),     ISPICKVAL(Last_Disposition__c,&quot;Contacted&quot;),     ISPICKVAL(Last_Detail__c,&quot;Confirmed with Customer&quot;)   ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Lead Notification</fullName>
        <actions>
            <name>New_Lead_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Store_chosen__c=true, Owner:User.Profile.Name =&apos;TMX Store Agent&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Overnight Lead</fullName>
        <actions>
            <name>Overnight_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Owner:Queue.QueueName =&apos;Overnight Lead Queue&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Assigned Time</fullName>
        <actions>
            <name>Owner_Assigned_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
   AND(ISCHANGED(OwnerId),Owner:User.Id&lt;&gt;null),
   AND(ISNEW(),Owner:User.Id&lt;&gt;null)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Store Email Field</fullName>
        <actions>
            <name>Populate_Store_Email_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ischanged(Store_ID__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SA Overnight</fullName>
        <actions>
            <name>SA_Overnight</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OR( AND(Day__c=&apos;Saturday&apos;,OR(Current_Local_Time__c&lt;10,Current_Local_Time__c &gt;= 16)), AND(OR(Day__c=&apos;Monday&apos;,Day__c=&apos;Tuesday&apos;,Day__c=&apos;Wednesday&apos;,Day__c=&apos;Thursday&apos;,Day__c=&apos;Friday&apos;) , OR(Current_Local_Time__c &lt; 9,Current_Local_Time__c &gt;= 19)) ),Store_Agent_Assigned__c=true)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send IL Appointment Email</fullName>
        <actions>
            <name>Send_IL_Appt_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and(  
Store_Name__r.Store_Type__c=&quot;InstaLoan&quot;,
or(
ischanged( Appointment_Date_Time__c ), 
ischanged( Store_Email__c )),
not(isblank( Appointment_Date_Time__c )), 
not(isblank( Store_Email__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send TB Appointment Email</fullName>
        <actions>
            <name>TitleBucks_Email_Appointment_Set</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and(  
Store_Name__r.Store_Type__c=&quot;TitleBucks&quot;,
or(
ischanged( Appointment_Date_Time__c ), 
ischanged( Store_Email__c )), 
not(isblank( Appointment_Date_Time__c )), 
not(isblank( Store_Email__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send TM Appointment Email</fullName>
        <actions>
            <name>Send_TitleMax_Appt_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and(  
Store_Name__r.Store_Type__c=&quot;TitleMax&quot;,
or( 
ischanged( Appointment_Date_Time__c ), 
ischanged( Store_Email__c )), 
not(isblank( Appointment_Date_Time__c )), 
not(isblank( Store_Email__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetRecordTypeToClosed</fullName>
        <actions>
            <name>SetRecordTypeToClosed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetRecordTypeToOSR</fullName>
        <actions>
            <name>SetRecordtypeToOSR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp;   NOT(ISPICKVAL(Status, &apos;Closed&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Time Zone Restricted - EST</fullName>
        <actions>
            <name>Time_Zone_Rest_EST</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Time_zone__c</field>
            <operation>equals</operation>
            <value>EST</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Current_Local_Time__c</field>
            <operation>equals</operation>
            <value>21</value>
        </criteriaItems>
        <description>EST time zone restriction indicator</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Time Zone Restricted - MST</fullName>
        <actions>
            <name>Time_Zone_Rest_MST</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.Time_zone__c</field>
            <operation>equals</operation>
            <value>MST</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Current_Local_Time__c</field>
            <operation>equals</operation>
            <value>7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Current_Local_Time__c</field>
            <operation>equals</operation>
            <value>6</value>
        </criteriaItems>
        <description>MST time zone restriction indicator</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Time Zone Restricted - PST</fullName>
        <actions>
            <name>Time_Zone_Rest_PST</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Lead.Time_zone__c</field>
            <operation>equals</operation>
            <value>PST</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Current_Local_Time__c</field>
            <operation>equals</operation>
            <value>6</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Current_Local_Time__c</field>
            <operation>equals</operation>
            <value>7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Current_Local_Time__c</field>
            <operation>equals</operation>
            <value>5</value>
        </criteriaItems>
        <description>PST time zone restriction indicator</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Time Zone Restricted -CST</fullName>
        <actions>
            <name>Time_Zone_Rest_CST</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Time_zone__c</field>
            <operation>equals</operation>
            <value>CST</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Current_Local_Time__c</field>
            <operation>equals</operation>
            <value>7</value>
        </criteriaItems>
        <description>CST time zone restriction indicator</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UI Created Lead</fullName>
        <actions>
            <name>Update_Lead_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>UI Lead</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UserToQueue</fullName>
        <actions>
            <name>Lead_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     ISCHANGED(OwnerId),     BEGINS(PRIORVALUE(OwnerId),&quot;005&quot;),      BEGINS(OwnerId, &quot;00G&quot;),      Lead_Assigned__c=true )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ValidLeadForCapacity</fullName>
        <actions>
            <name>ValidLeadForCapacity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(Status ),ISPICKVAL(Status,&quot;New&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VehicleMakeBB</fullName>
        <actions>
            <name>Update_Make_Picklist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( NOT(ISPICKVAL(Vehicle_Make_BB__c,&quot;&quot;)) &amp;&amp; NOT(ISPICKVAL(Vehicle_Make_BB__c,&quot;--Other--&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VehicleModelBB</fullName>
        <actions>
            <name>Update_Model_Picklist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( NOT(ISPICKVAL(Vehicle_Model_BB__c,&quot;&quot;)) &amp;&amp; NOT(ISPICKVAL(Vehicle_Model_BB__c,&quot;--Other--&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VehicleYearBB</fullName>
        <actions>
            <name>Update_Vehicle_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( NOT(ISPICKVAL(Vehicle_Year_BB__c,&quot;&quot;)) &amp;&amp; NOT(ISPICKVAL(Vehicle_Year_BB__c,&quot;--Other--&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFPermanentLeadClosed</fullName>
        <actions>
            <name>FUForPermanentLeadClosed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Total_Contact_Attempts__c</field>
            <operation>equals</operation>
            <value>8</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Funded,Funded:Confirmed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Web to Lead Reassign</fullName>
        <actions>
            <name>Set_Reassign_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Web to Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Initial_Call_Attempt</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Initial Call Attempt</subject>
    </tasks>
</Workflow>
