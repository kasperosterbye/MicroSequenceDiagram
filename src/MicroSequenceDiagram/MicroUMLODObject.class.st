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

{ #category : 'as yet unclassified' }
MicroUMLODObject class >> build3x3 [

	| grid |
	grid := OrderedCollection new.
	grid addAll: ((1 to: 9) collect: [ :i |
				 | label |
				 label := i odd ifTrue: [
						          ({ 3. 7 } includes: i)
							          ifTrue: [ self new build1 ]
							          ifFalse: [ self new build2 ] ].
				 label ]).
	^ grid
]

{ #category : 'as yet unclassified' }
MicroUMLODObject >> build1 [

	name := 'aCapitalCity'.
	variables := #( #( 'UK' 'London' ) #( 'USA' 'Washington' ) #( 'Germany' 'Berlin' ) )
]

{ #category : 'as yet unclassified' }
MicroUMLODObject >> build2 [

	name := 'aCapitalCity'.
	className := 'Exp'.
	variables := #( #( 'UK' 'London' ) #( 'USA' 'Washington' ) )
]

{ #category : 'accessing' }
MicroUMLODObject >> className [
	^ className
]

{ #category : 'accessing' }
MicroUMLODObject >> className: anObject [
	className := anObject
]

{ #category : 'accessing' }
MicroUMLODObject >> fullName [
	^ className 
		ifNotNil: [ name , ': ', className ] 
		ifNil: [ name ]
]

{ #category : 'initialization' }
MicroUMLODObject >> initialize [
	"#name . #className . #variables"
	name := 'kilroy'.
	className := nil.
	variables := OrderedCollection new.
]

{ #category : 'accessing' }
MicroUMLODObject >> name [
	^ name
]

{ #category : 'accessing' }
MicroUMLODObject >> name: anObject [
	name := anObject
]

{ #category : 'accessing' }
MicroUMLODObject >> variables [

	^ variables
]

{ #category : 'accessing' }
MicroUMLODObject >> variables: anObject [

	variables := anObject
]
