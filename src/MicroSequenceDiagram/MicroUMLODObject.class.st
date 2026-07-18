Class {
	#name : 'MicroUMLODObject',
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
MicroUMLODObject class >> example01 [
	| canvas |
	canvas := RSCanvas new.
	canvas add: (MicroUMLObjectDiagram new name: 'Object'; className: 'Class'; x: 100; y: 100; draw).
	canvas @ RSCanvasController.
	canvas openWithTitle: 'Object Diagram' "classified: 'examples'"
]

{ #category : 'accessing' }
MicroUMLODObject >> className [
	^ className
]

{ #category : 'accessing' }
MicroUMLODObject >> className: anObject [
	className := anObject
]

{ #category : 'initialization' }
MicroUMLODObject >> initialize [

]

{ #category : 'accessing' }
MicroUMLODObject >> name [
	^ name
]

{ #category : 'accessing' }
MicroUMLODObject >> name: anObject [
	name := anObject
]
