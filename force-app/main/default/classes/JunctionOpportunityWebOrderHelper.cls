public with sharing class JunctionOpportunityWebOrderHelper {
    public static List<Web_Order__c> newWebOrders;
    public static List<Opportunity> newOpportunities;
    public static Boolean flag = true;
    // public static final String OPPORTUNITY_TRIGGER='opportunityTrigger';
    // public static final String WEBORDER_TRIGGER='webOrderTrigger';
    public static List<JunctionOpportunityWebOrder__c> getRelatedJunctions(
            List<Opportunity> opl
    ) {
        return [
                SELECT Opportunity__c, Web_Order__c
                FROM JunctionOpportunityWebOrder__c
                WHERE Opportunity__c IN :opl
        ];
    }
    public static List<JunctionOpportunityWebOrder__c> getRelatedJunctions(
            List<Web_Order__c> wol
    ) {

        return [
                SELECT Opportunity__c, Web_Order__c
                FROM JunctionOpportunityWebOrder__c
                WHERE Web_Order__c IN :wol
        ];
    }
    public static List<JunctionOpportunityWebOrder__c> createNewJunctions() {
        List<JunctionOpportunityWebOrder__c> junctions = new List<JunctionOpportunityWebOrder__c>();

        for (Integer i = 0; i < newOpportunities.size(); i++) {
            JunctionOpportunityWebOrder__c jun = new JunctionOpportunityWebOrder__c();
            jun.Opportunity__c = JunctionOpportunityWebOrderHelper.newOpportunities[i]
                    .Id;
            jun.Web_Order__c = JunctionOpportunityWebOrderHelper.newWebOrders[i].Id;
            junctions.add(jun);
        }
        return junctions;
    }
    static {
        newWebOrders = new List<Web_Order__c>();
        newOpportunities = new List<Opportunity>();
    }

}