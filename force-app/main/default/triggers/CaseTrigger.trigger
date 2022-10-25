/**
 * @File               : 
 * @Description        : 
 * @Author             : Yassine RAZAQ (yrazaq@salesforce.com)
 * @Group              : 
 * @Last Modified On   : 25/10/2022
 * @Modification Log   :
 *======================================================================================
 * Ver         Date                           Author                  Modification
 *======================================================================================
 * 1.0      25/10/2022                   Yassine RAZAQ               Initial version
 **/
trigger CaseTrigger on Case (before insert, before update, after update) {
    new CaseTriggerHandler().run();
}