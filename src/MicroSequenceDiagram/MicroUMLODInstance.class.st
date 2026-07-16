Class {
	#name : 'MicroUMLODInstance',
	#superclass : 'Object',
	#instVars : [
		'name',
		'className',
		'variables'
	],
	#category : 'MicroSequenceDiagram-MicroUmlObjectDiagram',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUmlObjectDiagram'
}

{ #category : 'examples' }
MicroUMLODInstance class >> example01 [
	| canvas |
	canvas := RSCanvas new.
	canvas add: (MicroUMLObjectDiagram new name: 'Object'; className: 'Class'; x: 100; y: 100; draw).
	canvas @ RSCanvasController.
	canvas openWithTitle: 'Object Diagram' "classified: 'examples'"
]

{ #category : 'accessing' }
MicroUMLODInstance >> className [
	^ className
]

{ #category : 'accessing' }
MicroUMLODInstance >> className: anObject [
	className := anObject
]

{ #category : 'initialization' }
MicroUMLODInstance >> initialize [

]

{ #category : 'accessing' }
MicroUMLODInstance >> name [
	^ name
]

{ #category : 'accessing' }
MicroUMLODInstance >> name: anObject [
	name := anObject
]
