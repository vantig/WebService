public with sharing class WebOrderHelper {
    public static List<Web_Order__c> getRelatedWebOrders(
            List<JunctionOpportunityWebOrder__c> junctions
    ) {
        List<Id> IdWebOrders = new List<Id>();

        for (JunctionOpportunityWebOrder__c jun : junctions) {
            IdWebOrders.add(jun.Web_Order__c);
        }

        List<String> webOrderFields = getWebOrderFieldsFromFS();

        String query = 'SELECT ' + String.join(webOrderFields, ',') + ', Id FROM Web_Order__c WHERE Id IN:IdWebOrders';

        return Database.query(query);
    }
    public static List<String> getWebOrderFieldsFromFS() {
        List<String> webOrderFields = new List<String>();

        Map<String, Schema.FieldSet> WebOrderFs = Schema.SObjectType.Web_Order__c.fieldSets.getMap();

        for (Schema.FieldSet fs : WebOrderFs.values()) {
            for (Schema.FieldSetMember fsm : fs.getFields()) {
                webOrderFields.add(fsm.getFieldPath());
            }
        }

        return webOrderFields;
    }
    public static Web_Order__c createWebOrder(Opportunity op) {
        Web_Order__c wo = new Web_Order__c();

        List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsFromFS();

        List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsFromFS();

        for (Integer i = 0; i < opportunityFields.size(); i++) {
            wo.put(webOrderFields[i], op.get(opportunityFields[i]));
        }

        return wo;
    }
    public static List<Web_Order__c> getRelatedWebOrders(List<Opportunity> opl) {
        List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(
                opl
        );

        if (junctions == null) {
            return new List<Web_Order__c>();
        }

        List<Web_Order__c> webOrders = WebOrderHelper.getRelatedWebOrders(
                junctions
        );
        return webOrders;
    }
}