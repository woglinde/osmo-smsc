forward
forwardMessage
	| operationName operation param invoke |

	operationName := self class forwardSMName.
	operation := deliveryDialogue rosOperationNamed: operationName.

	param := operation newArgumentValue.
	(param expandFieldNamed: 'sm-RP-DA')
			at: 'imsi' put: imsi.
	(param expandFieldNamed: 'sm-RP-OA') 
			at: 'serviceCentreAddressOA' put: smscNumber toE164.
	param at: 'sm-RP-UI' put: self formatMessage.

	"If we have more messages, indicate that"
	pendingMessages size > 1 ifTrue: [
		param at: 'moreMessagesToSend' put: nil].

	invoke := deliveryDialogue requestTcInvokeNamed: operationName parameters: param class: 1 timeout: 60.
	invoke
		onReturn: [self signalForwardFailure: 'return'];
		onError: [self signalForwardFailure: 'error'];
		onReject: [self signalForwardFailure: 'reject'];
		onLCancel: [self signalForwardFailure: 'cancel'];
		onReturnLast: [:res | self signalForwardSuccess].