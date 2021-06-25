public with sharing class TriggerFactory {
  public static void createHandler(Schema.SObjectType soType) {
    ITrigger handler = getHandler(soType);

    if (handler == null) {
      throw new TriggerException(
        'No Trigger Handler registered for Object Type: ' + soType
      );
    }
    if (JunctionOpportunityWebOrderHelper.flag) {
      execute(handler);

    }
  }

  private static void execute(ITrigger handler) {

    if (Trigger.isBefore && Trigger.isInsert) {
      handler.onBeforeInsert();
    } else if (Trigger.isBefore && Trigger.isUpdate) {
      handler.onBeforeUpdate();
    } else if (Trigger.isBefore && Trigger.isDelete) {
      handler.onBeforeDelete();
    } else if (Trigger.isAfter && Trigger.isInsert) {
      handler.onAfterInsert();
    } else if (Trigger.isAfter && Trigger.isUpdate) {
      handler.onAfterUpdate();
    } else if (Trigger.isAfter && Trigger.isDelete) {
      handler.onAfterDelete();
    }
  }

  private static ITrigger getHandler(Schema.SObjectType soType) {
    if (soType == Opportunity.SObjectType) {
      return new OpportunityTriggerHandler();
    }
    if (soType == Web_Order__c.SObjectType) {
      return new WebOrderTriggerHandler();
    }
    return null;
  }
}