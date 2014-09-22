<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Collection_Dispostion_Promise_Kep</fullName>
        <field>Disposition__c</field>
        <literalValue>Promise Kept</literalValue>
        <name>Collection Dispostion Promise Kept</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disposition_Broken_Promise</fullName>
        <field>Disposition__c</field>
        <literalValue>Broken Promise</literalValue>
        <name>Disposition Broken Promise</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ending_Balance_Stamp</fullName>
        <field>Ending_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Ending Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Promise_End</fullName>
        <field>Last_Promise_End__c</field>
        <formula>today()</formula>
        <name>Last Promise End</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Promise_Start</fullName>
        <field>Last_Promise_Start__c</field>
        <formula>today()</formula>
        <name>Last Promise Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_PtP_Creator</fullName>
        <field>Last_PtP_Creator__c</field>
        <formula>CreatedBy.FirstName +&quot; &quot;+ CreatedBy.LastName</formula>
        <name>Last PtP Creator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_1</fullName>
        <field>Pymt_1_Amt__c</field>
        <formula>if(
and(
Number_of_Payments__c &gt; 0,
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c /  Number_of_Payments__c,
if(
and(
Number_of_Payments__c &gt; 0,
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c,
if(
Number_of_Payments__c &gt; 0,
Payment__c,
null)))</formula>
        <name>Payment Amount 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_10</fullName>
        <field>Pymt_10_Amt__c</field>
        <formula>if( 
and( 
Number_of_Payments__c &gt; 9, 
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c / Number_of_Payments__c, 
if( 
and( 
Number_of_Payments__c &gt; 9, 
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c, 
null))</formula>
        <name>Payment Amount 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_2</fullName>
        <field>Pymt_2_Amt__c</field>
        <formula>if(
and(
Number_of_Payments__c &gt; 1,
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c /  Number_of_Payments__c,
if(
and(
Number_of_Payments__c &gt; 1,
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c,
null))</formula>
        <name>Payment Amount 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_3</fullName>
        <field>Pymt_3_Amt__c</field>
        <formula>if(
and(
Number_of_Payments__c &gt; 2,
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c /  Number_of_Payments__c,
if(
and(
Number_of_Payments__c &gt; 2,
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c,
null))</formula>
        <name>Payment Amount 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_4</fullName>
        <field>Pymt_4_Amt__c</field>
        <formula>if(
and(
Number_of_Payments__c &gt; 3,
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c /  Number_of_Payments__c,
if(
and(
Number_of_Payments__c &gt; 3,
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c,
null))</formula>
        <name>Payment Amount 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_5</fullName>
        <field>Pymt_5_Amt__c</field>
        <formula>if(
and(
Number_of_Payments__c &gt; 4,
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c /  Number_of_Payments__c,
if(
and(
Number_of_Payments__c &gt; 4,
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c,
null))</formula>
        <name>Payment Amount 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_6</fullName>
        <field>Pymt_6_Amt__c</field>
        <formula>if( 
and( 
Number_of_Payments__c &gt; 5, 
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c / Number_of_Payments__c, 
if( 
and( 
Number_of_Payments__c &gt; 5, 
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c, 
null))</formula>
        <name>Payment Amount 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_7</fullName>
        <field>Pymt_7_Amt__c</field>
        <formula>if( 
and( 
Number_of_Payments__c &gt; 6, 
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c / Number_of_Payments__c, 
if( 
and( 
Number_of_Payments__c &gt; 6, 
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c, 
null))</formula>
        <name>Payment Amount 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_8</fullName>
        <field>Pymt_8_Amt__c</field>
        <formula>if( 
and( 
Number_of_Payments__c &gt; 7, 
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c / Number_of_Payments__c, 
if( 
and( 
Number_of_Payments__c &gt; 7, 
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c, 
null))</formula>
        <name>Payment Amount 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Amount_9</fullName>
        <field>Pymt_9_Amt__c</field>
        <formula>if( 
and( 
Number_of_Payments__c &gt; 8, 
ispickval( Schedule_Type__c,&quot;Divide&quot;)), 
Payment__c / Number_of_Payments__c, 
if( 
and( 
Number_of_Payments__c &gt; 8, 
ispickval( Schedule_Type__c,&quot;Repeat&quot;)), 
Payment__c, 
null))</formula>
        <name>Payment Amount 9</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_1</fullName>
        <field>Pymt_1_Date__c</field>
        <formula>if( Number_of_Payments__c &gt; 0,  Start_Date__c , null)</formula>
        <name>Payment Date 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_10</fullName>
        <field>Pymt_10_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 9,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+9,
if( 
and(
Number_of_Payments__c &gt; 9,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+63,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+126,
if( 
and(
Number_of_Payments__c &gt; 9,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;3),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+9,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 9,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;4),
date(Year(Start_Date__c),
Month(Start_Date__c)+9,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+135,
 null))))))</formula>
        <name>Payment Date 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_2</fullName>
        <field>Pymt_2_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+1,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+7,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+14,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;11),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+1,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;12),
date(Year(Start_Date__c),
Month(Start_Date__c)+1,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+15,
null))))))</formula>
        <name>Payment Date 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_3</fullName>
        <field>Pymt_3_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 2,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+2,
if( 
and(
Number_of_Payments__c &gt; 2,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+14,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+28,
if( 
and(
Number_of_Payments__c &gt; 2,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;10),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+2,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 2,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;11),
date(Year(Start_Date__c),
Month(Start_Date__c)+2,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+30,
 null))))))</formula>
        <name>Payment Date 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_4</fullName>
        <field>Pymt_4_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 3,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+3,
if( 
and(
Number_of_Payments__c &gt; 3,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+21,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+42,
if( 
and(
Number_of_Payments__c &gt; 3,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;9),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+3,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 3,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;10),
date(Year(Start_Date__c),
Month(Start_Date__c)+3,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+45,
 null))))))</formula>
        <name>Payment Date 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_5</fullName>
        <field>Pymt_5_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 4,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+4,
if( 
and(
Number_of_Payments__c &gt; 4,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+28,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+56,
if( 
and(
Number_of_Payments__c &gt; 4,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;8),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+4,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 4,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;9),
date(Year(Start_Date__c),
Month(Start_Date__c)+4,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+60,
 null))))))</formula>
        <name>Payment Date 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_6</fullName>
        <field>Pymt_6_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 5,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+5,
if( 
and(
Number_of_Payments__c &gt; 5,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+35,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+70,
if( 
and(
Number_of_Payments__c &gt; 5,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;7),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+5,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 5,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;8),
date(Year(Start_Date__c),
Month(Start_Date__c)+5,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+75,
 null))))))</formula>
        <name>Payment Date 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_7</fullName>
        <field>Pymt_7_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 6,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+6,
if( 
and(
Number_of_Payments__c &gt; 6,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+42,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+84,
if( 
and(
Number_of_Payments__c &gt; 6,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;6),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+6,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 6,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;7),
date(Year(Start_Date__c),
Month(Start_Date__c)+6,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+90,
 null))))))</formula>
        <name>Payment Date 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_8</fullName>
        <field>Pymt_8_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 7,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+7,
if( 
and(
Number_of_Payments__c &gt; 7,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+49,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+98,
if( 
and(
Number_of_Payments__c &gt; 7,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;5),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+7,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 7,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;6),
date(Year(Start_Date__c),
Month(Start_Date__c)+7,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+105,
 null))))))</formula>
        <name>Payment Date 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Date_9</fullName>
        <field>Pymt_9_Date__c</field>
        <formula>if( 
and(
Number_of_Payments__c &gt; 8,
ispickval( Installment_Period__c,&quot;Daily&quot;)),  Start_Date__c+8,
if( 
and(
Number_of_Payments__c &gt; 8,
ispickval( Installment_Period__c,&quot;Weekly&quot;)),  Start_Date__c+56,
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Bi-Weekly&quot;)),  Start_Date__c+112,
if( 
and(
Number_of_Payments__c &gt; 8,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c &gt;4),
date(Year(Start_Date__c)+1, 
Mod(Month(Start_Date__c)+8,12),
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 8,
ispickval( Installment_Period__c,&quot;Monthly&quot;), Start_Date_Month__c&lt;5),
date(Year(Start_Date__c),
Month(Start_Date__c)+8,
Day(Start_Date__c)),
if( 
and(
Number_of_Payments__c &gt; 1,
ispickval( Installment_Period__c,&quot;Semi-Monthly&quot;)),
Start_Date__c+120,
 null))))))</formula>
        <name>Payment Date 9</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Promise_to_Pay_Disposition</fullName>
        <field>Disposition__c</field>
        <literalValue>Promise to Pay</literalValue>
        <name>Promise to Pay Disposition</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Collection__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_10_Courtesy</fullName>
        <field>Pymt_10_Courtesy__c</field>
        <formula>if(
Pymt_10_Date__c &gt; today() + 3,
datetimevalue(Pymt_10_Date__c) - 2,
null)</formula>
        <name>Pymt 10 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_1_Balance_Stamp</fullName>
        <field>X1st_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 1 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_1_Courtesy</fullName>
        <field>Pymt_1_Courtesy__c</field>
        <formula>if(
Pymt_1_Date__c &gt; today() + 3,
datetimevalue(Pymt_1_Date__c) - 2,
null)</formula>
        <name>Pymt 1 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_2_Balance_Stamp</fullName>
        <field>X2nd_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 2 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_2_Courtesy</fullName>
        <field>Pymt_2_Courtesy__c</field>
        <formula>if(
Pymt_2_Date__c &gt; today() + 3,
datetimevalue(Pymt_2_Date__c) - 2,
null)</formula>
        <name>Pymt 2 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_3_Balance_Stamp</fullName>
        <field>X3rd_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 3 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_3_Courtesy</fullName>
        <field>Pymt_3_Courtesy__c</field>
        <formula>if(
Pymt_3_Date__c &gt; today() + 3,
datetimevalue(Pymt_3_Date__c) - 2,
null)</formula>
        <name>Pymt 3 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_4_Balance_Stamp</fullName>
        <field>X4th_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 4 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_4_Courtesy</fullName>
        <field>Pymt_4_Courtesy__c</field>
        <formula>if(
Pymt_4_Date__c &gt; today() + 3,
datetimevalue(Pymt_4_Date__c) - 2,
null)</formula>
        <name>Pymt 4 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_5_Balance_Stamp</fullName>
        <field>X5th_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 5 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_5_Courtesy</fullName>
        <field>Pymt_4_Courtesy__c</field>
        <formula>if(
Pymt_5_Date__c &gt; today() + 3,
datetimevalue(Pymt_5_Date__c) - 2,
null)</formula>
        <name>Pymt 5 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_6_Balance_Stamp</fullName>
        <field>X6th_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 6 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_6_Courtesy</fullName>
        <field>Pymt_6_Courtesy__c</field>
        <formula>if(
Pymt_6_Date__c &gt; today() + 3,
datetimevalue(Pymt_6_Date__c) - 2,
null)</formula>
        <name>Pymt 6 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_7_Balance_Stamp</fullName>
        <field>X7th_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 7 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_7_Courtesy</fullName>
        <field>Pymt_7_Courtesy__c</field>
        <formula>if(
Pymt_7_Date__c &gt; today() + 3,
datetimevalue(Pymt_7_Date__c) - 2,
null)</formula>
        <name>Pymt 7 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_8_Balance_Stamp</fullName>
        <field>X8th_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 8 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_8_Courtesy</fullName>
        <field>Pymt_8_Courtesy__c</field>
        <formula>if(
Pymt_8_Date__c &gt; today() + 3,
datetimevalue(Pymt_8_Date__c) - 2,
null)</formula>
        <name>Pymt 8 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_9_Balance_Stamp</fullName>
        <field>X9th_Pay_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Pymt 9 Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pymt_9_Courtesy</fullName>
        <field>Pymt_9_Courtesy__c</field>
        <formula>if(
Pymt_9_Date__c &gt; today() + 3,
datetimevalue(Pymt_9_Date__c) - 2,
null)</formula>
        <name>Pymt 9 Courtesy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Starting_Balance_Stamp</fullName>
        <field>Starting_Balance_Stamp__c</field>
        <formula>Collection__r.Balance_Less_Payments__c</formula>
        <name>Starting Balance Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Number_of_Payments</fullName>
        <field>Number_of_Payments__c</field>
        <formula>if(
not(isblank(Pymt_10_Date__c)),10,
if(
not(isblank(Pymt_9_Date__c)),9,
if(
not(isblank(Pymt_8_Date__c)),8,
if(
not(isblank(Pymt_7_Date__c)),7,
if(
not(isblank(Pymt_6_Date__c)),6,
if(
not(isblank(Pymt_5_Date__c)),5,
if(
not(isblank(Pymt_4_Date__c)),4,
if(
not(isblank(Pymt_3_Date__c)),3,
if(
not(isblank(Pymt_2_Date__c)),2,
if(
not(isblank(Pymt_1_Date__c)),1,
0))))))))))</formula>
        <name>Update Number of Payments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>1-9 Pays Balance Stamps</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Charge_Off_Balance__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Promise_to_Pay__c.Inactive__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_3_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_3_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_2_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_2_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_9_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_9_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_5_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_5_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_1_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_1_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_4_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_4_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_6_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_6_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_7_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_7_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Pymt_8_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_8_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Final Pay Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and( not(isblank(Starting_Balance_Stamp__c )), not(isblank(Ending_Balance_Stamp__c)),  Inactive__c=False, (Starting_Balance_Stamp__c-Ending_Balance_Stamp__c)&lt;  Total_Promise__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.PtP_Final_Date__c</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 1 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and(  not(isblank( X1st_Pay_Balance_Stamp__c )),  not(isblank(Starting_Balance_Stamp__c)),  not(isblank( Pymt_2_Date__c)), not(isblank( Pymt_1_Date__c)), Inactive__c=False,  (Starting_Balance_Stamp__c-X1st_Pay_Balance_Stamp__c)&lt; Pymt_1_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_1_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 2 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and(  not(isblank( X1st_Pay_Balance_Stamp__c )), not(isblank(X2nd_Pay_Balance_Stamp__c)), not(isblank( Pymt_2_Date__c)), not(isblank( Pymt_3_Date__c)), Inactive__c=False, (X1st_Pay_Balance_Stamp__c-X2nd_Pay_Balance_Stamp__c)&lt;  Pymt_2_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_2_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 3 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and( not(isblank( X3rd_Pay_Balance_Stamp__c )), not(isblank(X2nd_Pay_Balance_Stamp__c)), not(isblank( Pymt_3_Date__c)), not(isblank( Pymt_4_Date__c)),Inactive__c=False,(X2nd_Pay_Balance_Stamp__c-X3rd_Pay_Balance_Stamp__c)&lt;  Pymt_3_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_3_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 4 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and( not(isblank( X3rd_Pay_Balance_Stamp__c )), not(isblank(X4th_Pay_Balance_Stamp__c)), not(isblank( Pymt_4_Date__c)), not(isblank( Pymt_5_Date__c)),Inactive__c=False,(X3rd_Pay_Balance_Stamp__c-X4th_Pay_Balance_Stamp__c)&lt;  Pymt_4_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_4_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 5 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and( not(isblank( X5th_Pay_Balance_Stamp__c )), not(isblank(X4th_Pay_Balance_Stamp__c)), not(isblank( Pymt_5_Date__c)), not(isblank( Pymt_6_Date__c)),Inactive__c=False,(X4th_Pay_Balance_Stamp__c-X5th_Pay_Balance_Stamp__c)&lt;  Pymt_5_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_5_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 6 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and( not(isblank( X5th_Pay_Balance_Stamp__c )), not(isblank(X6th_Pay_Balance_Stamp__c)), not(isblank( Pymt_6_Date__c)), not(isblank( Pymt_7_Date__c)),Inactive__c=False,(X5th_Pay_Balance_Stamp__c-X6th_Pay_Balance_Stamp__c)&lt;  Pymt_6_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_6_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 7 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and( not(isblank( X7th_Pay_Balance_Stamp__c )), not(isblank(X6th_Pay_Balance_Stamp__c)), not(isblank( Pymt_7_Date__c)), not(isblank( Pymt_8_Date__c)),Inactive__c=False,(X6th_Pay_Balance_Stamp__c-X7th_Pay_Balance_Stamp__c)&lt;  Pymt_7_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_7_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 8 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and( not(isblank( X7th_Pay_Balance_Stamp__c )), not(isblank(X8th_Pay_Balance_Stamp__c)), not(isblank( Pymt_8_Date__c)), not(isblank( Pymt_9_Date__c)),Inactive__c=False,(X7th_Pay_Balance_Stamp__c-X8th_Pay_Balance_Stamp__c)&lt;  Pymt_8_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_8_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pay 9 Disposition Broken Promise</fullName>
        <active>true</active>
        <formula>and( not(isblank( X9th_Pay_Balance_Stamp__c )), not(isblank(X8th_Pay_Balance_Stamp__c)), not(isblank( Pymt_9_Date__c)), not(isblank( Pymt_10_Date__c)),Inactive__c=False,(X8th_Pay_Balance_Stamp__c-X9th_Pay_Balance_Stamp__c)&lt;  Pymt_9_Amt__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disposition_Broken_Promise</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_9_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Payment Amounts</fullName>
        <actions>
            <name>Payment_Amount_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_10</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_4</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_5</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_6</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_7</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_8</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Amount_9</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Promise_to_Pay__c.Payment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Payment Dates</fullName>
        <actions>
            <name>Payment_Date_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_10</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_4</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_5</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_6</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_7</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_8</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Payment_Date_9</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Promise_to_Pay__c.Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Collections PtP Creator</fullName>
        <actions>
            <name>Last_PtP_Creator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>0=0</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Last Promise Start%2FEnd</fullName>
        <actions>
            <name>Last_Promise_End</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Last_Promise_Start</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>0=0</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Promise to Pay 1 Courtesy Reminders</fullName>
        <active>false</active>
        <formula>Pymt_1_Date__c &gt; datevalue(CreatedDate) + 7</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_1_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Promise to Pay 1-10 Courtesy Reminders</fullName>
        <actions>
            <name>Pymt_10_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_1_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_2_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_3_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_4_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_5_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_6_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_7_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_8_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pymt_9_Courtesy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Promise_to_Pay__c.Inactive__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Promise to Pay 2-10 Courtesy Reminders</fullName>
        <active>false</active>
        <formula>Number_of_Payments__c &gt; 1</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_4_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_2_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_3_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_5_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_6_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_7_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_8_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_9_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.Pymt_10_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Starting Balance Stamp</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Charge_Off_Balance__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Starting_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.Pymt_1_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Ending_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.PtP_Final_Date__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Starting%2FEnding Balance Stamps</fullName>
        <actions>
            <name>Starting_Balance_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Charge_Off_Balance__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Promise_to_Pay__c.Inactive__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Ending_Balance_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.PtP_Final_Date__c</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Promise_to_Pay__c.CreatedDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Disposition to Promise Kept</fullName>
        <active>true</active>
        <formula>and(  not(isblank( Ending_Balance_Stamp__c)),  not(isblank( Starting_Balance_Stamp__c)),  Inactive__c=True, or( (Starting_Balance_Stamp__c-Ending_Balance_Stamp__c)&gt; Total_Promise__c, (Starting_Balance_Stamp__c-Ending_Balance_Stamp__c)= Total_Promise__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Collection_Dispostion_Promise_Kep</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Promise_to_Pay__c.PtP_Final_Date__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Number of Payments</fullName>
        <actions>
            <name>Update_Number_of_Payments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update disposition Promise to Pay</fullName>
        <actions>
            <name>Promise_to_Pay_Disposition</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
