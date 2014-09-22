/**
* @author Erashad Kurawle
* @company Bluewolf
* @date 01/29/2014
* @description Model class for Record Types.
* @name RecordTypeModel.cls
* @type Model Class
*/

/**
* @description Queue Service class.
*/
public class RecordTypeModel {
	public static Id getRecordTypeIdByName(String name){
		Id recordTypeId = [Select Id, name From RecordType where name =:name].Id; 
		return recordTypeId;
	}
}