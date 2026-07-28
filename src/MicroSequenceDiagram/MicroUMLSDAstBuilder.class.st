Class {
	#name : 'MicroUMLSDAstBuilder',
	#superclass : 'Object',
	#instVars : [
		'actors',
		'messages',
		'actorOrMessage',
		'lastMethod'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'UML - class separators' }
MicroUMLSDAstBuilder class >> , aString [
    ^ self new , aString
]

{ #category : 'examples' }
MicroUMLSDAstBuilder class >> example1 [
	"Example demonstrating the creation and linking of UML elements"

	(MicroUMLSDAstBuilder
    , 'Playground'
    , 'Login System' @ [ Transcript << 'Was here' << String lf ]
    , 'Database'
    & 'Playground' -> 'Login System' => 'call'
    & 'Login System' -> 'Database' => ('verify', String lf, 'Now') 
			@ [  Transcript << 'Kilroy' << String lf  ]
    & 'Database' -> 'Playground' --> '')
	renderDiagram.
]

{ #category : 'examples' }
MicroUMLSDAstBuilder class >> example2 [
	"Example demonstrating the creation and linking of UML elements"

	(MicroUMLSDAstBuilder
    , 'Playground'
    , 'Login System' @ [ Transcript << 'Was here' << String lf ]
    , 'Database'
    & 'Playground' -> 'Login System' => 'call'
	 & 'Login System' => 'Joe call'
    & 'Login System' -> 'Database' => ('verify', String lf, 'Now') 
			@ [  Transcript << 'Kilroy' << String lf  ]
    & 'Database' -> 'Playground' --> '')
	renderDiagram
]

{ #category : 'examples' }
MicroUMLSDAstBuilder class >> example30 [

	(MicroUMLSDAstBuilder
    , 'App'
    , 'API'
    , 'LLM'
	 , 'Weather Tool'
	
    & 'App' -> 'API' => '1: send besked'
	 "note right of API: chatHistory += msg(bruger)"
	 & 'API' -> 'LLM' => '2: send historik'
	 & 'LLM' -> 'API' => '3: tool_call(get_temp, "København")'
	 & 'API' -> 'Weather Tool' => ':4: get_temp("København")'
	 & 'Weather Tool' -> 'API' --> '5: 14°C'
	 & 'API' -> 'LLM' => '6: tool_result(14°C)'
	 & 'LLM' -> 'API' --> '7: answer user'
	 "note right of API: chatHistory += msg(assistent)"
	 & 'API' -> 'App' --> '8: show response')
	renderDiagram
]

{ #category : 'examples' }
MicroUMLSDAstBuilder class >> example35 [

	| micro |
	micro := (MicroUMLSDAstBuilder
    , 'App'
    , 'API'
    , 'LLM'
	 , 'Weather Tool'
	
    & 'App' ->+ 'API' => '1: send besked'
	 "note right of API: chatHistory += msg(bruger)"
	 & 'API' ->+ 'LLM' => '2: send historik'
	 & 'LLM' ->+ 'API' => '3: tool_call(get_temp, "København")'
	 "external call"
	 & 'API' ->+ 'Weather Tool' => '4: get_temp("København")'
	 & 'Weather Tool' -> 'API' --> '5: 14°C'
	 & 'API' -> 'LLM' --> '6: tool_result(14°C)'
	 & 'LLM' -> 'API' --> '7: answer user'
	 "note right of API: chatHistory += msg(assistent)"
	 & 'API' -> 'App' --> '8: show response').
	micro renderDiagram
]

{ #category : 'examples' }
MicroUMLSDAstBuilder class >> example5 [
	"Example demonstrating the creation and linking of UML elements"

	(MicroUMLSDAstBuilder
    , 'A'
    , 'Login System' @ [ Transcript << 'Was here' << String lf ]
    , 'Database'
    & 'A' -> 'Login System' => 'call'
	 & 'Login System' => 'Joe call'
    & 'Login System' -> 'Database' => ('verify', String lf, 'Now') 
			@ [  Transcript << 'Kilroy' << String lf  ]
    & 'Database' -> 'A' --> '')
	renderDiagram
]

{ #category : 'logical operations' }
MicroUMLSDAstBuilder >> & from [
	"Adds a new message to the sequence diagram, specifying the sender and receiver."
	messages add: (MicroUMLSDMessages new
		fromActor: (actors at: from);
		toActor: nil;
		index: messages size + 1).
	actorOrMessage := messages last.
	^ self
]

{ #category : 'UML - class separators' }
MicroUMLSDAstBuilder >> , aString [
	"Adds a new actor to the sequence diagram if it doesn't already exist"

	messages ifNotEmpty: [ ^ self error: 'No new usage of `,` after an `&`' ].
	(actors includesKey: aString) ifTrue: [ ^ self ].
	actors add: aString -> (MicroUMLSDActor new
			 name: aString;
			 index: actors size + 1).
	actorOrMessage := actors values at: actors size.
	^ self
]

{ #category : 'UML - class separators' }
MicroUMLSDAstBuilder >> --> aString [
	"Sets the message type to return and updates the message description"

	| message messageType |
	message := messages last.
	messageType := #return.
	message toActor 
		ifNil: [ message toActor: message fromActor]
		"ifNotNil: [ message fromActor lifeLineDownOn: messages size.]".
	message activationNesting.
	message
			 description: aString;
			 messageType: messageType.
	^ self
]

{ #category : 'logical operations' }
MicroUMLSDAstBuilder >> -> to [
	"Adds a new message to the sequence diagram, specifying the sender and receiver"
    messages last toActor: (actors at: to) .
    ^ self
]

{ #category : 'logical operations' }
MicroUMLSDAstBuilder >> ->+ to [
	 | toActor |
	 toActor := (actors at: to).
    messages last 
		toActor: (actors at: to);
	 	activationNesting.
    ^ self
]

{ #category : 'UML - class separators' }
MicroUMLSDAstBuilder >> => aString [
	"Sets the message type to call and updates the message description"

	| message messageType |
	message := messages last.
	messageType := #call.
	message toActor ifNil: [ 
		message toActor: message fromActor.
		messageType := #internal ].
   message
			 description: aString;
			 messageType: messageType ";
			 lastMethod: lastMethod";
			 yourself.
    ^ self
]

{ #category : 'UML - class separators' }
MicroUMLSDAstBuilder >> @ aBlock [
	"Attaches a block to the last actor or message, executed when clicked in the diagram"
	
	actorOrMessage clickAction: aBlock.
	
	^ self
]

{ #category : 'building' }
MicroUMLSDAstBuilder >> actorsAndMessages [
	^ { actors values. messages }
]

{ #category : 'initialization' }
MicroUMLSDAstBuilder >> initialize [ 
	"Initialises the builder with empty collections for actors and messages"

	actors := OrderedDictionary new.
	messages := OrderedCollection new
]

{ #category : 'accessing' }
MicroUMLSDAstBuilder >> lastMethod: meth [
	"Sets the last method used in a message for the builder"
	lastMethod := meth
]

{ #category : 'building' }
MicroUMLSDAstBuilder >> renderDiagram [
	(MicroUMLSequenceDiagram fromActorsAndMessages: self actorsAndMessages ) renderDiagram
]
