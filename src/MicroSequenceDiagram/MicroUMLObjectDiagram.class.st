Class {
	#name : 'MicroUMLObjectDiagram',
	#superclass : 'Object',
	#instVars : [
		'instances',
		'relations',
		'canvas',
		'uiTitle'
	],
	#category : 'MicroSequenceDiagram-MicroUmlObjectDiagram',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUmlObjectDiagram'
}

{ #category : 'instance creation' }
MicroUMLObjectDiagram class >> fromActorsAndMessages: aAndM [
	| instanse |
	instanse := self new.
	instanse actorsAndMessages: aAndM.
	^ instanse
]

{ #category : 'instance creation' }
MicroUMLObjectDiagram class >> fromInstancesAndRelations: iAndR [
	| instanse |
	instanse := self new.
	instanse instancesAndRelations: iAndR.
	^ instanse 
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> computeActorPositions [
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
MicroUMLObjectDiagram >> computeMessagePositions [
	"Computes the vertical positions of messages based on their order and a fixed gap"
    relations doWithIndex: [ :msg :i |
        msg y: MicroUMLSDMessages topMargin + (i * MicroUMLSDMessages messageGap) ]
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawActors [
	"Draws all actors on the canvas"
	canvas addAll: (actors collect: [ :actor | actor draw ])
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawInsances [
	canvas addAll: (instances collect: [ :actor | actor draw ])
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawLifelines [
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
MicroUMLObjectDiagram >> drawMessages [
	"Draws all messages on the canvas"
    messages do: [ :msg | canvas addAll: msg draw ]
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawRelations [
	"Draws all messages on the canvas"
    relations do: [ :msg | canvas addAll: msg draw ]
]

{ #category : 'initialization' }
MicroUMLObjectDiagram >> initialize [
	instances := OrderedCollection new.
	relations := OrderedCollection new.
	uiTitle := 'Object Diagram'.
]

{ #category : 'accessing' }
MicroUMLObjectDiagram >> instancesAndRelations: iAndR [
	instances := iAndR first.
	relations := iAndR second.
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> lifelineHeight [
	"Returns the total height of the lifeline based on the number of messages and fixed margins"
	
    ^ MicroUMLSDMessages topMargin 
        + (messages size * MicroUMLSDMessages messageGap) 
        + MicroUMLSDMessages bottomMargin
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> renderDiagram [

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
MicroUMLObjectDiagram >> uiTitle: title [
	"Sets the title of the sequence diagram"
	uiTitle := title.
]
