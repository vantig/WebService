public with sharing class WebOrderTriggerHandler implements ITrigger {
  public void onBeforeInsert() {
    JunctionOpportunityWebOrderHelper.flag = false;

    List<Opportunity> opportunities = new List<Opportunity>();

    for (Integer i = 0; i < Trigger.new.size(); i++) {
      opportunities.add(
        OpportunityHelper.createOpportunity((Web_Order__c) Trigger.new[i])
      );
      JunctionOpportunityWebOrderHelper.newWebOrders.add(
        (Web_Order__c) Trigger.new[i]
      );
      JunctionOpportunityWebOrderHelper.newOpportunities.add(opportunities[i]);
    }
    insert opportunities;
    JunctionOpportunityWebOrderHelper.flag = true;
  }

  public void onBeforeUpdate() {
    JunctionOpportunityWebOrderHelper.flag = false;
    List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(
      (List<Web_Order__c>) Trigger.new
    );
    List<Opportunity> opportunities = OpportunityHelper.getRelatedOpportunities(
      (List<Web_Order__c>) Trigger.new
    );
    Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>(opportunities);

    Map<Id, Web_Order__c> webOrderMap = new Map<Id, Web_Order__c>( (List<Web_Order__c>) Trigger.new);

    for (JunctionOpportunityWebOrder__c jun : junctions) {
      copyWebOrder(
        webOrderMap.get(jun.Web_Order__c),
        opportunityMap.get(jun.Opportunity__c)
      );
    }
    update opportunities;
    JunctionOpportunityWebOrderHelper.flag = true;
  }

  public void onBeforeDelete() {
    JunctionOpportunityWebOrderHelper.flag = false;
    delete OpportunityHelper.getRelatedOpportunities(
      (List<Web_Order__c>) Trigger.old
    );
    JunctionOpportunityWebOrderHelper.flag = true;
  }
  public void onAfterInsert() {
    JunctionOpportunityWebOrderHelper.flag = false;

    insert JunctionOpportunityWebOrderHelper.createNewJunctions();
    JunctionOpportunityWebOrderHelper.flag = true;
  }
  public void onAfterUpdate() {
    JunctionOpportunityWebOrderHelper.flag = true;
  }
  public void onAfterDelete() {
    JunctionOpportunityWebOrderHelper.flag = true;
  }
  private void copyWebOrder(Web_Order__c wo, Opportunity op) {
    List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsFromFS();

    List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsFromFS();

    for (Integer i = 0; i < opportunityFields.size(); i++) {
      op.put(opportunityFields[i], wo.get(webOrderFields[i]));
    }
  }
}