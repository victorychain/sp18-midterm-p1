pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */


/** Beginning and Ending Index;
[01234]

[X____] add first one: beginning = 0; ending =1;
[XXX__] add three time: beginning = 0; ending = 3;
[_XX__] delete first one: beginning = 1; ending =3;
[__X__] delete second one: 2 | 3;
[__XX_] add one more: 2 | 4;
[__XXX] add one more: 2 | 5 > 0;
[X_XXX] add one more: 2 | 1;
[XXXXX] add one more: 2 | 2;
[_____] delete all: 2>3>4>5(0)>1 | 2;

size:
--- (if ending > beginning) ending - beginning;
--- ( if ending < beginning) ending + 5 - beginning;
--- same number = no item;


*/

contract Queue {
	/* State variables */
	uint8 size = 5;
	// YOUR CODE HERE
	uint beginningIndex = 0;
	uint endingIndex = 0;
	mapping(uint => address) indexToAddress;
	mapping(address => uint) addressToIndex;
	mapping(address => uint) addressToTimeConsumed;
	uint public timeCap;

	/* Add events */
	// YOUR CODE HERE
	event QueueRemoved(address removedQueueAdress);
	event QueueAdded(address addedQueueAdress);

	/* Add constructor */
	// YOUR CODE HERE
	// [Later]
	function Queue(uint timeCapI) {
		timeCap = timeCapI;
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		// YOUR CODE HERE
		if (endingIndex < beginningIndex) {
			return endingIndex + size - beginningIndex;
		} else {
			// also handle if 0 size here;
			return endingIndex - beginningIndex;;
		}
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		// YOUR CODE HERE
		return endingIndex == beginningIndex;
	}
	
	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		// YOUR CODE HERE
		if (qsize == 1) {
			return;
		}
		address res =  indexToAddress[beginningIndex];
		dequeue();
		return res;
	}
	
	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		// YOUR CODE HERE
		uint indexPosition = addressToIndex[msg.sender];
		if (indexPosition == -1) {
			return -1
		} else if (indexPosition >= beginningIndex) {
			return indexPosition - beginningIndex;
		} else {
			return indexPosition + size - beginningIndex;
		}

	}
	
	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		// YOUR CODE HERE

			uint currentIndex = beginningIndex;
			address currentAddress = indexToAddress[currentIndex];
			uint currentTimeConsumed = now - addressToTimeConsumed[currentAddress]

			while (currentTimeConsumed > timeCap) {
				QueueRemoved(currentAddress);
				addressToIndex[indexToAddress[beginningIndex]] = -1;
				beginningIndex = (beginningIndex + 1) % size;
				currentIndex = beginningIndex;
				currentAddress = indexToAddress[currentIndex];
				currentTimeConsumed = now - addressToTimeConsumed[currentAddress]
			}

	}
	
	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		// YOUR CODE HERE
		if (qsize == 1) {
			return;
		}
		QueueRemoved(indexToAddress[beginningIndex]);
		addressToIndex[indexToAddress[beginningIndex]] = -1;
		beginningIndex = (beginningIndex + 1) % size;

	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		// YOUR CODE HERE

		// if the queue is already full, don't do it.
		if (qsize() == size) {
			return;
		}
		indexToAddress[endingIndex] = addr;
		addressToIndex[msg.sender] = endingIndex;
		QueueAdded(addr);
		addressToTimeConsumed[msg.sender] = now;
		endingIndex = (endingIndex + 1) % size;
	}
}
