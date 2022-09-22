public with sharing class ContactController {

    public String searchKey {get; set;}

    public List<Contact> contacts {get; set;}

    public List<Contact> getContacts() {
        contacts = [
            SELECT Id, AccountId, FirstName, LastName, Email, MobilePhone, Account.Name, CreatedDate
            FROM Contact
            LIMIT 100
        ];
        return null;
    }

    public List<Contact> searchContacts() {
        searchKey = searchKey.trim();
        searchKey = '%' + searchKey + '%';
        contacts = [
            SELECT Id, AccountId, FirstName, LastName, Email, MobilePhone, Account.Name, CreatedDate
            FROM Contact
            WHERE Name LIKE :searchKey
            LIMIT 100
        ];
        return null;
    }
}