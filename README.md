# BuyThoseTickets
We want to create a Smart Contract in order for our users to buy tickets to different events so the ownership of the ticket is stored in the blockchain.

# Methods params

## Add event
Adds a new event to the list while assigning a maximum number of tickets to be sold along with the price of each ticket in Ether.
Returns a success code.
It can only be called by the owner of the contract

Params:
- `Name`
- `Date`
- `Amount of tickets`
- `Ticket price`
  
## Get event information
Read Only method that returns the information of a given event.
Should return also how many tickets are left. This is important because the buyers must know if the tickets were sold or they can still buy them.

Params:
  - `Event Name`

## Buy ticket
Any address can buy a ticket by calling this method by adding the price of the entrance to the transaction.
The method will register the address as the owner of a ticket of a given event.
An address can only own a single ticket from each event.
Tickets can only be purchased if they are available.
Returns a success code.

Params:
  - `Event Name`

## Ticket owned
Read only method that any address can call to check all events that the sender address has ownership of a ticket.

Params:
  - `Event Name`

## Resell ticket
An address owning a ticket of an event can change the ownership of a ticket to another address.
It can only be called by the address that owns the ticket of an event.

Params:
  - `Event name`
  - `Destination address`
