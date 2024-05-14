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
        address ticketOwner;
    }

    // It's not a list but this map looks nice in solidity :)
    mapping(string => Event) public events;

    /**
     * Adds a new event to the list while assigning a maximum number of tickets to be sold along with the price of each ticket in Ether.
     * Returns a success code.
     * It can only be called by the owner of the contract.
     */
    function addEvent(string memory name, uint256 date, uint256 amountOfTickets, uint256 ticketPrice) public isOwner returns (bool) {
        // if the events[name] already exists the data will be override, but I don't care about this at the moment.
        Event storage newEvent = events[name];
        newEvent.name = name;
        newEvent.date = date;
        newEvent.amountOfTickets = amountOfTickets;
        newEvent.ticketPrice = ticketPrice;
        newEvent.ticketsSold = 0;
        return true;
    }
    
}
