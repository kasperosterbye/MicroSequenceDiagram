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
	 & 'Login System' => 'self call'
    & 'Login System' -> 'Database' => ('verify', String lf, 'Now') 
			@ [  Transcript << 'Kilroy' << String lf  ]
    & 'Database' -> 'Playground' --> '')
	renderDiagram
]

{ #category : 'logical operations' }
MicroUMLSDAstBuilder >> & from [
	"Adds a new message to the sequence diagram, specifying the sender and receiver."
	messages add: (MicroUMLSDMessages new
		fromActor: (actors at: from);
		toActor: nil).
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
	message toActor ifNil: [ message toActor: message fromActor].
	message
			 description: aString;
			 messageType: messageType;
			 yourself.
	^ self
]

{ #category : 'logical operations' }
MicroUMLSDAstBuilder >> -> to [
	"Adds a new message to the sequence diagram, specifying the sender and receiver"

    messages last toActor: (actors at: to) .
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
			 messageType: messageType ;
			 lastMethod: lastMethod;
			 yourself.
    ^ self
]

{ #category : 'UML - class separators' }
MicroUMLSDAstBuilder >> @ aBlock [
	"Attaches a block to the last actor or message, executed when clicked in the diagram"
	
	actorOrMessage clickAction: aBlock.
	
	^ self
]

{ #category : 'accessing' }
MicroUMLSDAstBuilder >> actors [
	"Returns the collection of actors in the sequence diagram"
self halt.
	^ actors values
]

{ #category : 'building' }
MicroUMLSDAstBuilder >> actorsAndMessages [
	^ { actors values. messages }
]

{ #category : 'building' }
MicroUMLSDAstBuilder >> build [
	self error: 'Use renderDiagram instead' .
	(MicroUMLSequenceDiagram from: self) build
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

{ #category : 'accessing' }
MicroUMLSDAstBuilder >> messages [
	"Returns the collection of messages exchanged between actors in the sequence diagram"

	^ messages 
]

{ #category : 'building' }
MicroUMLSDAstBuilder >> renderDiagram [
	(MicroUMLSequenceDiagram from: self actorsAndMessages ) renderDiagram
]
