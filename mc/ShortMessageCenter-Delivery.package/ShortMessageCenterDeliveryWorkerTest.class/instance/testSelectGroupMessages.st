tests-as yet unclassified
testSelectGroupMessages
	"Add messages"
	| messages groups |
	smscDatabase
		insertShortMessage: 'This is a message1' destination: '1234567890' source: '1234' deliverIn: 0 seconds expireIn: 10 days receivedOn: 'link1';
		insertShortMessage: 'This is a message2' destination: '1234567890' source: '1235' deliverIn: 0 seconds expireIn: 10 days receivedOn: 'link2';
		insertShortMessage: 'This is a message3' destination: '1234567890' source: '1236' deliverIn: 0 seconds expireIn: 10 days receivedOn: 'link3';
		insertShortMessage: 'This is a message4' destination: '1234567890' source: '1234' deliverIn: 0 seconds expireIn: 10 days receivedOn: 'link1';
		insertShortMessage: 'This is a message5' destination: '1234567890' source: '1234' deliverIn: 0 seconds expireIn: 10 days receivedOn: 'link1'.

	"Add routes"
	omDatabase
		createOrUpdateDeliveryRoute: (ShortMessageDeliveryRoute new
												routeName: 'r1';
												destinationAddressPrefix: '12345';
												yourself);
		createOrUpdateDeliveryRoute: (ShortMessageDeliveryRoute new
												routeName: 'r2';
												destinationAddressPrefix: '12345';
												sourceAddressPrefix: '1234';
												yourself);
		createOrUpdateDeliveryRoute: (ShortMessageDeliveryRoute new
												routeName: 'r3';
												destinationAddressPrefix: '12345';
												sourceAddressPrefix: '1235';
												systemId: 'link2';
												yourself).

		messages := smscDatabase collectionForSms select: [:each |].
		groups := ShortMessageCenterDeliveryWorker new
							omDatabase: omDatabase;
							selectGroupMessages: messages.
		self assert: messages size equals: 5.
		self assert: groups size equals: 3.
		self assert: groups keys sort equals: #('r1' 'r2' 'r3').
		self assert: (groups at: 'r2') size equals: 3.
		self assert: (groups at: 'r1') size equals: 1.
		self assert: (groups at: 'r3') size equals: 1.
	
		self assert: ((groups at: 'r3') first at: 'encodedMessage') equals: 'This is a message2'.
		self assert: ((groups at: 'r1') first at: 'encodedMessage') equals: 'This is a message3'.