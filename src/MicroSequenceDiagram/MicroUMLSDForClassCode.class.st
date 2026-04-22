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
	actions do: [ :actorClass | 
		astBuilder , actorClass name asString @ [ AIAPresenter onComment: actorClass comment]].
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

{ #category : 'accessing' }
MicroUMLSDForClassCode >> scope: scope [
	classScope := scope 
]

{ #category : 'internals' }
MicroUMLSDForClassCode >> umlSPFor: message [
	| idx cList subList nextPackage |
	idx := message fifth first.
	cList := message fifth second.
	subList := cList copyFrom: idx to: cList size.
	nextPackage := { message second package name. message second packageTag name }.
	self class 
		forContext: subList 
		inScope: nextPackage
]
