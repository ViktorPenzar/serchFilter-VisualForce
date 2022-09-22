@isTest
public with sharing class ContactControllerTest {

    @testSetup
    static void createContacts() {
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            contactList.add(new Contact(FirstName='Test', LastName='Pass' + i));
        }
        insert contactList;
    }

    @isTest
    static void getContacts_loadContacts_contactsRecieved() {
        List<Contact> newContacts = [
            SELECT Id, AccountId, FirstName, LastName, Email, MobilePhone, Account.Name, CreatedDate
            FROM Contact
        ];
        Test.setCurrentPage(Page.searchFilter);
        ContactController controller = new ContactController();

        Test.startTest();
        controller.getContacts();
        List<Contact> returnedContacts = controller.contacts;
        Test.stopTest();

        System.assertEquals(newContacts, returnedContacts, 'Contacts were received');
        System.assert(returnedContacts.size() == 10, 'Was expecting to find ten contact');
    }

    @isTest
    static void searchContacts_loadContactsWithEmptySearchKey_contactsRecieved() {
        List<Contact> newContacts = [
            SELECT Id, AccountId, FirstName, LastName, Email, MobilePhone, Account.Name, CreatedDate
            FROM Contact
        ];
        Test.setCurrentPage(Page.searchFilter);
        ContactController controller = new ContactController();

        Test.startTest();
        controller.searchKey = '';
        controller.searchContacts();
        List<Contact> returnedContacts = controller.contacts;
        Test.stopTest();

        System.assertEquals(newContacts, returnedContacts, 'Contacts were received');
        System.assert(returnedContacts.size() == 10, 'Was expecting to find 10 of 10 contact');
    }

    @isTest
    static void searchContacts_loadContactBysearchKey_oneContactRecieved() {
        List<Contact> newContacts = [
            SELECT Id, AccountId, FirstName, LastName, Email, MobilePhone, Account.Name, CreatedDate
            FROM Contact
        ];
        Test.setCurrentPage(Page.searchFilter);
        ContactController controller = new ContactController();

        Test.startTest();
        controller.searchKey = '5';
        controller.searchContacts();
        List<Contact> returnedContacts = controller.contacts;
        Test.stopTest();

        System.assertNotEquals(newContacts, returnedContacts, 'One of the ten contacts was recieved');
        System.assert(returnedContacts.size() == 1, 'Was expecting to find 1 of 10 contacts');
    }

    @isTest
    static void searchContacts_loadContactWithWrongSearchKey_emptyList() {
        List<Contact> newContacts = [
            SELECT Id, AccountId, FirstName, LastName, Email, MobilePhone, Account.Name, CreatedDate
            FROM Contact
        ];
        Test.setCurrentPage(Page.searchFilter);
        ContactController controller = new ContactController();

        Test.startTest();
        controller.searchKey = '&*';
        controller.searchContacts();
        List<Contact> returnedContacts = controller.contacts;
        Test.stopTest();

        System.assertNotEquals(newContacts, returnedContacts, 'No Contacts recieved');
        System.assert(returnedContacts.size() == 0, 'Was expecting to find 0 of 10 contacts');
    }

    @isTest
    static void searchContacts_checkNegativeReturn_emptyList() {
        List<Contact> newContacts = [
            SELECT Id, AccountId, FirstName, LastName, Email, MobilePhone, Account.Name, CreatedDate
            FROM Contact
        ];
        delete newContacts;
        Test.setCurrentPage(Page.searchFilter);
        ContactController controller = new ContactController();

        Test.startTest();
        controller.searchKey = '';
        controller.searchContacts();
        List<Contact> returnedContacts = controller.contacts;
        Test.stopTest();

        System.assertNotEquals(newContacts, returnedContacts, 'No Contacts recieved');
        System.assert(returnedContacts.size() == 0, 'Was expecting to find 0 of 0 contacts');
    } 
}