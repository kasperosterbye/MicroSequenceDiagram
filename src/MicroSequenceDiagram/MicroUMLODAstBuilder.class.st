Class {
	#name : 'MicroUMLODAstBuilder',
	#superclass : 'Object',
	#instVars : [
		'instances',
		'relations'
	],
	#category : 'MicroSequenceDiagram-MicroUmlObjectDiagram',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUmlObjectDiagram'
}

{ #category : 'UML - class separators' }
MicroUMLODAstBuilder class >> === aString [
    ^ self new === aString
]

{ #category : 'examples' }
MicroUMLODAstBuilder class >> example1 [
	"Example demonstrating the creation and linking of UML elements"

	(MicroUMLODAstBuilder
    === 'Playground')
	renderDiagram.
]

{ #category : 'UML - class separators' }
MicroUMLODAstBuilder >> === aString [
	"Adds a new actor to the sequence diagram if it doesn't already exist"
	relations ifNotEmpty: [ ^ self error: 'No new usage of `===` after an `===>`' ].
	(instances includesKey: aString) ifTrue: [ ^ self ].
	instances add: aString -> (MicroUMLODInstance new
			 name: aString).
	"actorOrMessage := actors values at: actors size."
	^ self
]

{ #category : 'initialization' }
MicroUMLODAstBuilder >> initialize [ 
	"Initialises the builder with empty collections for actors and messages"

	instances := OrderedDictionary new.
	relations := OrderedCollection new
]

{ #category : 'building' }
MicroUMLODAstBuilder >> instancesAndRelations [
	^ { instances value. relations }
]

{ #category : 'building' }
MicroUMLODAstBuilder >> renderDiagram [
	(MicroUMLObjectDiagram fromInstancesAndRelations: self instancesAndRelations ) renderDiagram
]
