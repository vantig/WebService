trigger WebOrderTrigger on Web_Order__c(
  after delete,
  after insert,
  after undelete,
  after update,
  before delete,
  before insert,
  before update
) {
  TriggerFactory.createHandler(Web_Order__c.SObjectType);
}