Class {
	#name : 'MicroUMLSequenceDiagram',
	#superclass : 'Object',
	#instVars : [
		'actors',
		'messages',
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
				(msg fromActor = a and: [ msg toActor = b ]) or: [ msg fromActor = b and: [ msg toActor = a ] ] ].
			maxDistance := messagesBetween
				 ifEmpty: [ actorGap ]
				 ifNotEmpty: [ :msgs | 
				 	(msgs collect: [ :msg | (RSLabel new text: msg description) textWidth ]) max + actorGap + 10].
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
MicroUMLSequenceDiagram >> drawLifelines [
	"Draws the lifelines for each actor on the canvas"
    canvas addAll: (actors collect: [ :actor |
        RSLine new
            startPoint: actor x @ (MicroUMLSDActor boxHeight / 2);
            endPoint: actor x @ (MicroUMLSDActor boxHeight / 2 + self lifelineHeight);
            dashArray: #(5 5);
            color: Color black;
            yourself ])
]

{ #category : 'roassal' }
MicroUMLSequenceDiagram >> drawMessages [
	"Draws all messages on the canvas"
    messages do: [ :msg | canvas addAll: msg draw ]
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

{ #category : 'accessing' }
MicroUMLSequenceDiagram >> uiTitle: title [
	"Sets the title of the sequence diagram"
	uiTitle := title.
]
