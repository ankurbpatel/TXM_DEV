<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_IL_Appt_Email_Loan</fullName>
        <description>Send IL Appt Email Loan</description>
        <protected>false</protected>
        <recipients>
            <field>Store_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Center/InstaLoan_Manual_Appt_Set_Loan_VF</template>
    </alerts>
    <alerts>
        <fullName>Send_TitleMax_Appt_Email_Loan</fullName>
        <description>Send TitleMax Appt Email Loan</description>
        <protected>false</protected>
        <recipients>
            <field>Store_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Center/TM_Automated_Appointment_Set_Loan</template>
    </alerts>
    <alerts>
        <fullName>TitleBucks_Email_Appointment_Set_Loans</fullName>
        <description>TitleBucks Email Appointment Set Loans</description>
        <protected>false</protected>
        <recipients>
            <field>Store_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact_Center/TB_Automated_Appointment_Set_Loan</template>
    </alerts>
    <fieldUpdates>
        <fullName>Alt_Phone_Update</fullName>
        <field>Alternate_Phone__c</field>
        <formula>Edit_Alternate_Phone__c</formula>
        <name>Alt Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cell_Update</fullName>
        <field>PersonMobilePhone</field>
        <formula>Edit_Cell_Phone__c</formula>
        <name>Cell Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Contacted</fullName>
        <field>Contacted__c</field>
        <literalValue>1</literalValue>
        <name>Loan Contacted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Exclude_From_Bonus_False</fullName>
        <field>Exclude_from_Bonus__c</field>
        <literalValue>0</literalValue>
        <name>Loan Exclude From Bonus - False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Exclude_from_Bonus_True</fullName>
        <field>Exclude_from_Bonus__c</field>
        <literalValue>1</literalValue>
        <name>Loan Exclude from Bonus - True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Qualified</fullName>
        <field>Qualified__c</field>
        <literalValue>1</literalValue>
        <name>Loan Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phone_Update</fullName>
        <field>Phone</field>
        <formula>Edit_Phone__c</formula>
        <name>Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Store_Email_Field_Loan</fullName>
        <field>Store_Email__c</field>
        <formula>Store__r.Email_Address__c</formula>
        <name>Populate Store Email Field Loan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Sent_Loan</fullName>
        <field>Appointment_Email_Sent__c</field>
        <formula>now()</formula>
        <name>Update Email Sent Loan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Update_Year_Picklist</fullName>
        <field>Vehicle_Year__c</field>
        <formula>Text(Vehicle_Year_BB__c)</formula>
        <name>Update Year Picklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Appointment not kept</fullName>
        <actions>
            <name>Appointment_not_kept</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Appointment Not Kept</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Bad Phone Loan</fullName>
        <actions>
            <name>Loan_Exclude_from_Bonus_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Last_Disposition__c</field>
            <operation>equals</operation>
            <value>Bad Phone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Exclude_from_Bonus__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Bad Phone Loan - Undo</fullName>
        <actions>
            <name>Loan_Exclude_From_Bonus_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Last_Disposition__c</field>
            <operation>notEqual</operation>
            <value>Bad Phone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Exclude_from_Bonus__c</field>
            <operation>notEqual</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan Contacted</fullName>
        <actions>
            <name>Loan_Contacted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Contacted__c=FALSE,    OR(      ISPICKVAL(Last_Disposition__c,&quot;Appointment Not Kept&quot;),      ISPICKVAL(Last_Disposition__c,&quot;Contacted&quot;),      ISPICKVAL(Last_Disposition__c,&quot;Do Not Call&quot;),      ISPICKVAL(Last_Detail__c,&quot;Customer Does Not Qualify&quot;),      ISPICKVAL(Last_Detail__c,&quot;Confirmed with Customer&quot;)    ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan Qualified</fullName>
        <actions>
            <name>Loan_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Qualified__c=FALSE, OR( ISPICKVAL(Last_Disposition__c,&quot;Appointment Not kept&quot;), ISPICKVAL(Last_Disposition__c,&quot;Contacted&quot;), ISPICKVAL(Last_Detail__c,&quot;Confirmed with Customer&quot;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Store Email Field Loan</fullName>
        <actions>
            <name>Populate_Store_Email_Field_Loan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Store__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send IL Appointment Email Loan</fullName>
        <actions>
            <name>Send_IL_Appt_Email_Loan</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Sent_Loan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and(   Store__r.Store_Type__c=&quot;InstaLoan&quot;, or( ischanged( Appointment_Date_Time__c ),  ischanged( Store_Email__c )), not(isblank( Appointment_Date_Time__c )),  not(isblank( Store_Email__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send TB Appointment Email Loan</fullName>
        <actions>
            <name>TitleBucks_Email_Appointment_Set_Loans</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Sent_Loan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and( Store__r.Store_Type__c=&quot;TitleBucks&quot;, or( ischanged( Appointment_Date_Time__c ), ischanged( Store_Email__c )), not(isblank( Appointment_Date_Time__c )), not(isblank( Store_Email__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send TM Appointment Email Loan</fullName>
        <actions>
            <name>Send_TitleMax_Appt_Email_Loan</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Sent_Loan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and( Store__r.Store_Type__c=&quot;TitleMax&quot;, or( ischanged( Appointment_Date_Time__c ), ischanged( Store_Email__c )), not(isblank( Appointment_Date_Time__c )), not(isblank( Store_Email__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Alternate Phone</fullName>
        <actions>
            <name>Alt_Phone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ischanged(Edit_Alternate_Phone__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Cell Phone</fullName>
        <actions>
            <name>Cell_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ischanged(Edit_Cell_Phone__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Phone</fullName>
        <actions>
            <name>Phone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ischanged(Edit_Phone__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VehicleMakeLoanBB</fullName>
        <actions>
            <name>Update_Make_Picklist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (  NOT(ISPICKVAL(Vehicle_Make_BB__c,&quot;&quot;))  &amp;&amp;  NOT(ISPICKVAL(Vehicle_Make_BB__c,&quot;--Other--&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VehicleModelLoanBB</fullName>
        <actions>
            <name>Update_Model_Picklist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (  NOT(ISPICKVAL(Vehicle_Model_BB__c,&quot;&quot;))  &amp;&amp;  NOT(ISPICKVAL(Vehicle_Model_BB__c,&quot;--Other--&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VehicleYearLoanBB</fullName>
        <actions>
            <name>Update_Year_Picklist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (  NOT(ISPICKVAL(Vehicle_Year_BB__c,&quot;&quot;))  &amp;&amp;  NOT(ISPICKVAL(Vehicle_Year_BB__c,&quot;--Other--&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Appointment_not_kept</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Appointment not kept</subject>
    </tasks>
</Workflow>
