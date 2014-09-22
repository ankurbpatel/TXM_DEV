/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/25/2014
* @description Abstract class to help matching of leads to accounts and leads to leads.
* @name MatchHelperClass.cls
* @type Abstract Class
* @see LeadService.cls
*/
public abstract class MatchHelperClass {
/**
* @description All leads to be converted.
*/
protected Lead[] leads {get;set;}

/**
* @description Contains a Map of matching Lead and Account Id's
*/
public Map<Id,Id> perfectMatch {get;set;}

/**
* @description Contains a Map of leads with ambiguous matches and list of Account id's that match.
*/
public Map<Id,list<Id>> ambiguousMatch {get;set;}

/**
* @description This method performs the actual matching.
*/

public abstract void doMatching();

public abstract void takeActionAfterMatching();
}