sms-read
releaseDestination: aDestination
	| res now |
	now := DateAndTime now.
	res := database command: {
		'findAndModify' -> collectionForLock name.
		'query' -> [:item | (item destMSISDN = aDestination) ] asMongoQuery.
		'remove' -> true.
	} asDictionary.
	^res ifNotNil: [res at: 'value'].