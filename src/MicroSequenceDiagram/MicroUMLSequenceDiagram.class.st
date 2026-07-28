Class {
	#name : 'MicroUMLSequenceDiagram',
	#superclass : 'Object',
	#instVars : [
		'actors',
		'messages',
		'activationLevels',
		'canvas',
		'uiTitle'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'instance creation' }
MicroUMLSequenceDiagram class >> fromActorsAndMessages: aAndM [
	| instanse rsActors reMessages |
	rsActors := (aAndM first collect: [ :a | a name -> (MicroUMLSDrsActor new actor: a) ]) asOrderedDictionary .
	reMessages := aAndM second collect: [ :m | |rsM|
		rsM := MicroUMLSDrsMessages new message: m; yourself.
		rsM message fromActor: (rsActors at: rsM message fromActor name).
		rsM message toActor: (rsActors at: rsM message toActor name).
		rsM ].
	instanse := self new.
	instanse actorsAndMessages: { rsActors values. reMessages }.
	^ instanse
]

{ #category : 'accessing' }
MicroUMLSequenceDiagram >> actorsAndMessages: aAndM [
	actors := aAndM first.
	messages := aAndM second
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> computeActorPositions [
	"Computes the horizontal positions of actors based on message distances"

	| actorGap maxDistance |
	actorGap := MicroUMLSDActor actorGap.
	actors first x: actorGap.
	2 to: actors size do: [ :index |
			| a b messagesBetween |
			a := actors at: index -1.
			b := actors at: index .

			messagesBetween := messages select: [ :msg |
				(msg message fromActor = a and: [ msg message toActor = b ]) 
					or: [ msg message fromActor = b and: [ msg message toActor = a ] ] ].
			maxDistance := messagesBetween
				 ifEmpty: [ actorGap ]
				 ifNotEmpty: [ :msgs | 
				 	(msgs collect: [ :msg | 
						(RSLabel new text: msg message description) textWidth ]) max + actorGap + 10].
			b x: a x + (maxDistance max: (a width / 2) + (b width / 2) + (2*actorGap) )   ].
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> computeMessagePositions [
	"Computes the vertical positions of messages based on their order and a fixed gap"
    messages doWithIndex: [ :msg :i |
        msg y: MicroUMLSDMessages topMargin + (i * MicroUMLSDMessages messageGap) ]
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawActors [
	"Draws all actors on the canvas"
	canvas addAll: (actors collect: [ :actor | actor draw ])
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawLifeline: actor [

	| rectangle actorIndex messageIndex maxActivation|
	canvas add: (RSLine new
			 startPoint: actor x @ (MicroUMLSDActor boxHeight / 2);
			 endPoint: actor x @ (MicroUMLSDActor boxHeight / 2 + self lifelineHeight);
			 dashArray: #( 5 5 );
			 color: Color black;
			 yourself).
	actorIndex := actor actor index.
	messageIndex := messages size.
	maxActivation := 0.
	1 to: messageIndex do: [ :message |
		(activationLevels at: { actorIndex. message }) > maxActivation 
			ifTrue: [ maxActivation := activationLevels at: { actorIndex. message } ]
		 ].
	self halt.
	1 to: maxActivation do: [ :activationLevel |
		| start end |
		start := end := 0.
		
		 ].
	rectangle := RSBox new
		             translateTo: actor x @ 100;
		             width: 10;
		             height: 100;
		             color: Color white;
		             borderColor: Color black;
		             yourself.
	canvas add: rectangle
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawLifelines [
	"Draws the lifelines for each actor on the canvas"
    actors do: [ :actor | self drawLifeline: actor ]
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawMessages [
	"Draws all messages on the canvas"
    messages do: [ :msg | 
		canvas addAll: (msg draw: activationLevels) ]
]

{ #category : 'initialization' }
MicroUMLSequenceDiagram >> initialize [
	"Initialises the sequence diagram with empty collections for actors and messages, and sets the default gap between actors"
	actors := OrderedCollection new.
	messages := OrderedCollection new.
	uiTitle := 'Sequence Diagram'.
	"actorGap := MicroUMLSDActor actorGap."
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> lifelineHeight [
	"Returns the total height of the lifeline based on the number of messages and fixed margins"
    ^ MicroUMLSDMessages topMargin 
        + (messages size * MicroUMLSDMessages messageGap) 
        + MicroUMLSDMessages bottomMargin
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> renderDiagram [
	"Constructs and displays the sequence diagram on a canvas"
	
	self setActivationLevels.
	canvas := RSCanvas new.
	self 
		computeActorPositions;
		computeMessagePositions;
		drawActors;
		drawMessages;
		drawLifelines.
	canvas @ RSCanvasController.
	canvas openWithTitle: uiTitle
]

{ #category : 'initialization' }
MicroUMLSequenceDiagram >> setActivationLevels [

	activationLevels := OrderedDictionary new.
	actors do: [ :act | messages do: [ :msg | 
			activationLevels at: {act actor index. msg message index} put: 0 ] ].
	1 to: messages size do: [ :msgIndex |
			| msg from to prev |
			msg := messages at: msgIndex.
			from := msg message fromActor actor index.
			to := msg message toActor actor index.
			msg message activation ifTrue: [
				msg message messageType = #call ifTrue: 
					[  prev := msgIndex = 1
							ifTrue: [ 0 ]
							ifFalse: [ activationLevels at: {to . msgIndex - 1} ].
						msgIndex to: messages size do: [ :idxCall |
								activationLevels at: {to . idxCall} put: prev + 1
				 		] ].
				msg message messageType = #return ifTrue: 
					[ prev := msgIndex = 1
							ifTrue: [ 0 ]
							ifFalse: [ activationLevels at: {from . msgIndex - 1} ].
							msgIndex + 1 to: messages size do: [ :idxReturn |
								activationLevels at: {from . idxReturn} put: prev - 1
				 ] ] ].
			 ]
]

{ #category : 'initialization' }
MicroUMLSequenceDiagram >> setActivationLevels_old [

	activationLevels := OrderedDictionary new.
	actors do: [ :act | messages do: [ :msg | 
			activationLevels at: {act actor index. msg message index} put: 0 ] ].
	1 to: messages size do: [ :msgIndex |
			| msg from to prev |
			msg := messages at: msgIndex.
			from := msg fromActor.
			to := msg toActor.
			prev := msgIndex = 1
				        ifTrue: [ 0 ]
				        ifFalse: [ activationLevels at: to at: (messages at: msgIndex - 1) ].
			activationLevels at: to at: msg put: prev.
			msg message activation
				ifTrue: [
						msg messageType = #call ifTrue: [ activationLevels at: to at: msg put: prev + 1 ].
						msg messageType = #return ifTrue: [ activationLevels at: to at: msg put: prev - 1 ] ]
				ifFalse: [  ] ].
]

{ #category : 'initialization' }
MicroUMLSequenceDiagram >> setActivationLevels_old2 [

	activationLevels := OrderedDictionary new.
	actors do: [ :act | messages do: [ :msg | 
			activationLevels at: {act actor index. msg message index} put: 0 ] ].
	1 to: messages size do: [ :msgIndex |
			| msg from to prev next |
			msg := messages at: msgIndex.
			from := msg message fromActor actor index.
			to := msg message toActor actor index.
			prev := msgIndex = 1
				        ifTrue: [ 0 ]
				        ifFalse: [ activationLevels at: {to . msgIndex - 1} ].
			next := prev.
			msg message activation
				ifTrue: [
						msg message messageType = #call ifTrue: 
							[ next := prev + 1 ].
						msg message messageType = #return ifTrue: 
							[ next :=  prev - 1 ] ]
				ifFalse: [  ].
			msgIndex to: messages size do: [ :idx |
				activationLevels at: {to . idx} put: next
				 ] ].
]

{ #category : 'accessing' }
MicroUMLSequenceDiagram >> uiTitle: title [
	"Sets the title of the sequence diagram"
	uiTitle := title.
]
