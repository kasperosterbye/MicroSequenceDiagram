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

{ #category : 'as yet unclassified' }
MicroUMLSequenceDiagram >> activationCenterXFor: actor level: level [

	level = 0 ifTrue: [ ^ actor x ].
	^ actor x + ((level - 1) * 5)
]

{ #category : 'as yet unclassified' }
MicroUMLSequenceDiagram >> activationIntervalsFor: levels [

	| result maxLevel |

	levels ifEmpty: [ ^ #() ].

	result := OrderedCollection new.
	maxLevel := levels max.

	1 to: maxLevel do: [ :level |
		| start |

		start := nil.

		levels doWithIndex: [ :value :index |
			value >= level
				ifTrue: [
					start ifNil: [ start := index ] ]
				ifFalse: [
					start ifNotNil: [
						result add: {
							level.
							{ start. index - 1 } }.
						start := nil ] ] ].

		start ifNotNil: [
			result add: {
				level.
				{ start. levels size } } ] ].

	^ result asArray
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
	actorGap := MicroUMLSDrsActor actorGap.
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
        msg y: MicroUMLSDrsMessages topMargin + (i * MicroUMLSDrsMessages messageGap) ]
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawActors [
	"Draws all actors on the canvas"
	canvas addAll: (actors collect: [ :actor | actor draw ])
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawLifeline: actor [

	canvas add: (RSLine new
			 startPoint: actor x @ (MicroUMLSDrsActor boxHeight / 2);
			 endPoint: actor x @ (MicroUMLSDrsActor boxHeight / 2 + self lifelineHeight);
			 dashArray: #( 5 5 );
			 color: Color black;
			 yourself).
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawLifeline_old: actor [

	| rectangle actorIndex messageIndex maxActivation|
	canvas add: (RSLine new
			 startPoint: actor x @ (MicroUMLSDActor boxHeight / 2);
			 endPoint: actor x @ (MicroUMLSDActor boxHeight / 2 + self lifelineHeight);
			 dashArray: #( 5 5 );
			 color: Color black;
			 yourself).
	self lifelineList: actor.
	actorIndex := actor actor index.
	messageIndex := messages size.
	maxActivation := 0.
	1 to: messageIndex do: [ :message |
		(activationLevels at: { actorIndex. message }) > maxActivation 
			ifTrue: [ maxActivation := activationLevels at: { actorIndex. message } ]
		 ].
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
    actors do: [ :actor | 
		self drawLifeline: actor.
		self drawLineActivations: actor ]
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawLineActivations: actor [

	| activations activationWidth levelOffset |

	activationWidth := 10.
	levelOffset := activationWidth / 2.
	activations := self lifelineList: actor.

	activations do: [ :activation |
		| level interval startY endY height rectangle |

		level := activation first.
		interval := activation second.

		startY := (messages at: interval first) y.
		endY := (messages at: interval second) y.
		height := endY - startY.

		rectangle := RSBox new
			width: activationWidth;
			height: height;
			color: Color white;
			borderColor: Color black;
			translateTo:
				(actor x + ((level - 1) * levelOffset))
				@
				(startY + (height / 2));
			yourself.

		canvas add: rectangle ]
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
    ^ MicroUMLSDrsMessages topMargin 
        + (messages size * MicroUMLSDrsMessages messageGap) 
        + MicroUMLSDrsMessages bottomMargin
]

{ #category : 'as yet unclassified' }
MicroUMLSequenceDiagram >> lifelineList: actor [
	| actorIndex boxSizes boxes result  |
	actorIndex := actor actor index.
	boxSizes := OrderedCollection new.
	1 to: messages size do: [ :messageIndex |
		boxSizes add: (activationLevels at: {actorIndex . messageIndex })
		 ].
	result := self activationIntervalsFor: boxSizes asArray.
	^ result.
	
	
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
		drawLifelines;
		drawMessages.
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

{ #category : 'accessing' }
MicroUMLSequenceDiagram >> uiTitle: title [
	"Sets the title of the sequence diagram"
	uiTitle := title.
]
