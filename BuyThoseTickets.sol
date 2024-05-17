// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./2_Owner.sol";

/**
 * @title BuyThoseTickets
 * @dev A Smart Contract in order for our users to buy tickets to different events so the ownership of the ticket is stored in the blockchain
 */
contract BuyThoseTickets is Owner {

    struct Event {
        string name;
        uint256 date;
        uint256 amountOfTickets;
        uint256 ticketPrice;
        uint256 ticketsSold;
        mapping(address => bool) ticketOwners;
    }

    // count number of events
    uint256 public eventCount = 0;
    // map the events by id
    mapping(uint256 => Event) public events;
    // map an address to check the events owned
    mapping(address => mapping(uint256 => bool)) public ownership;

    // Event definitions; added, purchased, resold
    event EventAdded(uint256 eventId, string name, uint256 date, uint256 amountOfTickets, uint256 ticketPrice);
    event TicketPurchased(uint256 eventId, address buyer);
    event TicketResold(uint256 eventId, address from, address to);

    /**
     * Adds a new event to the list while assigning a maximum number of tickets to be sold along with the price of each ticket in Ether.
     * Returns a success codevt.
     * It can only be called by the owner of the contract.
     */
    function addEvent(string memory name, uint256 date, uint256 amountOfTickets, uint256 ticketPrice) public isOwner returns (bool) {
        // increment number of events
        eventCount++;
        // refer to data that is stored on the blockchain
        Event storage newEvent = events[eventCount];
        newEvent.name = name;
        newEvent.date = date;
        newEvent.amountOfTickets = amountOfTickets;
        newEvent.ticketPrice = ticketPrice;
        newEvent.ticketsSold = 0;
        // emit event (log) to make public to anyone
        emit EventAdded(eventCount, name, date, amountOfTickets, ticketPrice);
        return true;
    }

    /**
     * Read Only method that returns the information of a given event.
     * Should return also how many tickets are left.
     * This is important because the buyers must know if the tickets were sold or they can still buy them.
     */
    function getEventInfo(uint256 eventId) public view returns (string memory name, uint256 date, uint256 amountOfTickets, uint256 ticketsSold, uint256 ticketPrice, uint256 ticketsLeft) {
        Event storage evt = events[eventId];
        return (evt.name, evt.date, evt.amountOfTickets, evt.ticketsSold, evt.ticketPrice, evt.amountOfTickets - evt.ticketsSold);
    }

    /*
     * Any address can buy a ticket by calling this method by adding the price of the entrance to the transaction.
     * The method will register the address as the owner of a ticket of a given event.
     * An address can only own a single ticket from each event.
     * Tickets can only be purchased if they are available.
     * Returns a success code.
     */
    function buyTicket(uint256 eventId) public payable returns (bool) {
        Event storage evt = events[eventId];
        // require are like conditions
        require(msg.value == evt.ticketPrice, "Incorrect ether sent");
        require(evt.ticketsSold < evt.amountOfTickets, "All tickets already sold");
        // retrieve the tickets owned by the address and check if event id already exists, negate.
        require(!ownership[msg.sender][eventId], "Address already owns a ticket for this event");
        // add new owner to the owners of this ticket
        evt.ticketOwners[msg.sender] = true;
        ownership[msg.sender][eventId] = true;
        evt.ticketsSold++;
        emit TicketPurchased(eventId, msg.sender);
        return true;
    }

    /*
     * Read only method that any address can call to check all events that the sender address has ownership of a ticket.
     */
    function ticketsByOwner(address owner) public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](eventCount);
        uint counter = 0;
        // well, not sure if it should be a loop but here we are...
        for (uint256 i = 1; i <= eventCount; i++) {
            if (ownership[owner][i]) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    /*
    * An address owning a ticket of an event can change the ownership of a ticket to another address.
    * It can only be called by the address that owns the ticket of an event.
    */
    function resellTicket(uint256 eventId, address to) public returns (bool) {
        // need to be a owner
        require(ownership[msg.sender][eventId], "You do not own a ticket for this event");
        // not selling to someone already own one
        require(!ownership[to][eventId], "Recipient already owns a ticket for this event");
        // not owner anymore
        ownership[msg.sender][eventId] = false;
        ownership[to][eventId] = true;
        emit TicketResold(eventId, msg.sender, to);
        return true;
    }
    
}
