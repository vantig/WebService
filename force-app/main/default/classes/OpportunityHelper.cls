public with sharing class OpportunityHelper {
    public static List<String> getOpportunityFieldsFromFS() {
        List<String> opportunityFields = new List<String>();
        Map<String, Schema.FieldSet> opportunityFs = Schema.SObjectType.Opportunity.fieldSets.getMap();

        for (Schema.FieldSet fs : opportunityFs.values()) {
            for (Schema.FieldSetMember fsm : fs.getFields()) {
                opportunityFields.add(fsm.getFieldPath());
            }
        }

        return opportunityFields;
    }
    public static Opportunity createOpportunity(Web_Order__c wo) {
        Opportunity op = new Opportunity();

        List<String> opportunityFields = OpportunityHelper.getOpportunityFieldsFromFS();

        List<String> webOrderFields = WebOrderHelper.getWebOrderFieldsFromFS();

        for (Integer i = 0; i < opportunityFields.size(); i++) {
            op.put(opportunityFields[i], wo.get(webOrderFields[i]));
        }

        return op;
    }
    public static List<Opportunity> getRelatedOpportunities(
            List<JunctionOpportunityWebOrder__c> junctions
    ) {
        List<Id> IdOpportunities = new List<Id>();

        for (JunctionOpportunityWebOrder__c jun : junctions) {
            IdOpportunities.add(jun.Opportunity__c);
        }

        List<String> OpportunitiesFields = getOpportunityFieldsFromFS();

        String query = 'SELECT ' + String.join(OpportunitiesFields, ',') + ', Id FROM Opportunity WHERE Id IN:IdOpportunities';


        return Database.query(query);
    }
    public static List<Opportunity> getRelatedOpportunities(
            List<Web_Order__c> wol
    ) {
        List<JunctionOpportunityWebOrder__c> junctions = JunctionOpportunityWebOrderHelper.getRelatedJunctions(
                wol
        );

        if (junctions == null) {
            return new List<Opportunity>();
        }

        List<Opportunity> opportunities = OpportunityHelper.getRelatedOpportunities(
                junctions
        );
        return opportunities;
    }
}