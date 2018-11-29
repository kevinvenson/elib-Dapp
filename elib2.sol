pragma solidity ^0.4.24;

contract App {
    
    //Table for the list of Publishers
    struct Publisher {
        string publisherName;
        address publisherAddress;
    }
    
    // Table for the list of Books
    struct Book {
        string bookName;
        string authorName;
        uint publisherId;
    }
    
    // table for the list of Verifiers
    struct Verifier {
        string verifierName;
        address verifierAddress;
    }
    
    // table for the list of verified books
    struct VerifiedBook {
        address verifierAddress;
        string bookName;
    }
    
    // address of the msg.sender
    address owner;
    
    // amount of ether for buying a book
    uint amount = 1 ether;
    
    // returns the length of number of registered publishers/books/verifiers
    uint public publishersCount;
    uint public booksCount;
    uint public verifiersCount;
    
    // reference index for struct
    uint256 publisherId;
    uint256 bookId;
    uint256 verifierId;
    uint256 verifiedBooksId;
    
    // input integer returns the struct
    mapping(uint => Publisher) publishers;
    mapping(uint => Book) books;
    mapping(uint => Verifier) verifiers;
    mapping(uint => VerifiedBook) verifiedBooks;

    // checker if input address is publisher or verifier
    mapping(address => bool) public Publishers;
    mapping(address => bool) public Verifiers;

    // check if the address of verifier is legit/trusted by the system  
    mapping(address => bool) public status; 
    
    // initialization
    constructor() public {
        owner = msg.sender;
    }
    
    // requirements for functions that owner can only add
    modifier onlyOwner {
        require(owner==msg.sender);
        _;
    }
    
    // add publisher
    //required existing address and desired publisher name
    function addPublisher(address _publisherAddress, string _publisherName) public {
        require(msg.sender == _publisherAddress);
        Publisher memory newPublisher;
        
        Publishers[_publisherAddress] = true;
        
        newPublisher.publisherName = _publisherName;
        newPublisher.publisherAddress = _publisherAddress;
        
        publishers[publisherId] = newPublisher;
        
        publisherId++;
        publishersCount++;
    }
    
    // get specific publisher using it's id
    function getPublisher(uint _publisherId) view public returns(string, address) {
        return (publishers[_publisherId].publisherName, publishers[_publisherId].publisherAddress);
    }
    
    // add book
    // required existing publisher address and title of book
    function addBook(address _publisherAddress, string _bookName, string _authorName, uint _publisherId) public payable {
        require(msg.sender == _publisherAddress && containsPublisher(msg.sender) == true && msg.value >= amount);
        owner.transfer(amount);
        
        Book memory newBook;
        
        newBook.bookName = _bookName;
        newBook.authorName = _authorName;
        newBook.publisherId = _publisherId;
        
        publisherId++;
        booksCount++;
    }
    
    // get specific book using it's book id
    function getBook(uint _bookId) view public returns(string, string, uint) {
        return (books[_bookId].bookName,books[_bookId].authorName,books[_bookId].publisherId);
    }
    
    // add verifier
    // input existing address and desired verifier name
    function addVerifier(address _verifierAddress, string _verifierName) public {
        require(msg.sender == _verifierAddress);
        Verifier memory newVerifier;
        
        Verifiers[_verifierAddress] = true;
        
        newVerifier.verifierName = _verifierName;
        newVerifier.verifierAddress = _verifierAddress;
        
        verifiers[verifierId] = newVerifier;
        
        verifierId++;
        verifiersCount++;
    }
    
    //add verified books
    function addVerifiedBookBy(address _verifierAddress, string _bookName) view public {
           require(msg.sender==_verifierAddress);
           VerifiedBook memory newVerifiedBook;
           
           newVerifiedBook.verifierAddress = msg.sender;
           newVerifiedBook.bookName = _bookName;
    }
    
    function getVerifiedBook(uint _verifiedBooksId) view public returns (address, string) {
        return (verifiedBooks[_verifiedBooksId].verifierAddress, verifiedBooks[_verifiedBooksId].bookName);
    }
    
    // get specific verifier using it's id 
    function getVerifier(uint _verifierId) view public returns (string, address) {
        return (verifiers[_verifierId].verifierName, verifiers[_verifierId].verifierAddress);
    }
    
    // only owner function, add legit verifier
    //just like on fb or twitter the check logo after it's name
    function addLegitVerifier(address _verifierAddress) onlyOwner public {
        status[_verifierAddress] = true;
    }
    
    //returns if the verifier is legit or not
    // true == legit
    function getLegitVerifier(address _publisherAddress) public view returns (bool) {
        return status[_publisherAddress];
    }
    
    //checks if address is a registered publisher
    function containsPublisher(address _publisherAddress) public view returns (bool) {
        return Publishers[_publisherAddress];
    }
    
    // checks if address is registerd verifier
    function containsVerifier(address _verifierAddress) public view returns (bool) {
        return Publishers[_verifierAddress];
    }
    
}