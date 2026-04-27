Class {
	#name : 'MicroUMLSDForClassCode',
	#superclass : 'MicroUMLSDForCode',
	#instVars : [
		'classScope'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'internals' }
MicroUMLSDForClassCode >> ast41Title [

		^ 'Class: ' , classScope name.
]

{ #category : 'internals' }
MicroUMLSDForClassCode >> ast43BuildActors [
	astBuilder , 'O'. 
	super ast43BuildActors.
]

{ #category : 'internals' }
MicroUMLSDForClassCode >> classNameCheck: aClass [

	classScope ~= ProtoObject ifTrue: [ ^ aClass = classScope ].
	(self emptyPackageTestFor: aClass)
		ifFalse: [ ^ false ]
		ifTrue: [
				classScope := aClass.
				^ true ]
]

{ #category : 'internals' }
MicroUMLSDForClassCode >> openSubDiagramFor: message [
	| idx cList subList nextPackage |
	idx := message fifth first.
	cList := message fifth second.
	subList := cList copyFrom: idx to: cList size.
	nextPackage := message second.
	self class 
		forContext: subList 
		inScope: nextPackage
]

{ #category : 'accessing' }
MicroUMLSDForClassCode >> scope: scope [
	classScope := scope 
]
