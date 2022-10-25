/**
 * @File               : CaseTriggerHandler
 * @Description        : Trigger Handler for Trigger on Case Object
 * @Author             : Yassine RAZAQ (yrazaq@salesforce.com)
 * @Group              : 
 * @Last_Modified_On   : 25/10/2022
 * @Modification_Log   :
 *======================================================================================
 * Ver         Date                           Author                  Modification
 *======================================================================================
 * 1.0      25/10/2022                   Yassine RAZAQ               Initial version
 **/

public class CaseTriggerHandler extends TriggerHandler {
    private List<Case> newCases;
    private List<Case> oldCases;
    private Map<Id, Case> newCasesMap;
    private Map<Id, Case> oldCasesMap;

    public CaseTriggerHandler() {
        this.newCases = (List<Case>) Trigger.new;
        this.oldCases = (List<Case>) Trigger.old;
        this.newCasesMap = (Map<Id, Case>) Trigger.newMap;
        this.oldCasesMap = (Map<Id, Case>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        CaseHelper.checkAttendees(this.newCases);
    }

    public override void beforeUpdate() {
        System.debug('@yassine here');
        CaseHelper.checkAttendees(this.newCases);
    }

    public override void afterUpdate() {
        CaseHelper.handleClosedCases(this.newCases);
    }


}