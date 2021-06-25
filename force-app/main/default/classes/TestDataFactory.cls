public with sharing class TestDataFactory {

    public static void createWebOrdersTestRecords(Integer numWebOrders) {
        List<Web_Order__c> webOrders = new List<Web_Order__c>();
        for (Integer i = 0; i < numWebOrders; i++) {
            Web_Order__c wo = new Web_Order__c();
            wo.Name = 'Test';
            wo.Close_Date__c = Date.today();
            wo.Stage__c = 'Prospecting';
            webOrders.add(wo);
        }
        insert webOrders;
    }

    public static void createOpportunitiesTestRecords(Integer numOpportunities) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < numOpportunities; i++) {
            Opportunity opp = new Opportunity();
            opp.Name = 'Test';
            opp.CloseDate = Date.today();
            opp.StageName = 'Prospecting';
            opportunities.add(opp);
        }
        insert opportunities;
    }
}