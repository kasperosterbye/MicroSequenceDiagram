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
MicroUMLObjectDiagram class >> fromInstancesAndRelations: iAndR [
	| instanse |
	instanse := self new.
	instanse instancesAndRelations: iAndR.
	^ instanse 
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> computeInstancePositions [
	

	| actorGap maxDistance |
	actorGap := MicroUMLSDActor actorGap.
	instances first x: actorGap.
	2 to: instances size do: [ :index |
			| a b messagesBetween |
			a := instances at: index -1.
			b := instances at: index .

			"messagesBetween := messages select: [ :msg |
				(msg fromActor = a and: [ msg toActor = b ]) or: [ msg fromActor = b and: [ msg toActor = a ] ] ]."
			maxDistance := messagesBetween
				 ifEmpty: [ actorGap ]
				 ifNotEmpty: [ :msgs | 
				 	(msgs collect: [ :msg | (RSLabel new text: msg description) textWidth ]) max + actorGap + 10].
			b x: a x + (maxDistance max: (a width / 2) + (b width / 2) + (2*actorGap) )   ].
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawInsances [ 
	"Draws all actors on the canvas"
	canvas addAll: (instances collect: [ :actor | actor draw ])
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
	instances add: {#instance ->iAndR first. #x -> 0. #y ->0} asOrderedDictionary .
	"relations := iAndR second."
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> renderDiagram [

	canvas := RSCanvas new.
	self 
		computeInstancePositions;
		"computeMessagePositions;"
		drawInsances";
		drawLifelines;
		drawMessages".
	canvas @ RSCanvasController.
	canvas openWithTitle: uiTitle
]

{ #category : 'accessing' }
MicroUMLObjectDiagram >> uiTitle: title [
	"Sets the title of the sequence diagram"
	uiTitle := title.
]
