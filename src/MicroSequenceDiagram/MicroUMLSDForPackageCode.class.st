Class {
	#name : 'MicroUMLSDForPackageCode',
	#superclass : 'MicroUMLSDForCode',
	#instVars : [
		'packageScope'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'internals' }
MicroUMLSDForPackageCode >> ast41Title [
 
		packageScope ifEmpty: [ ^ 'All packages' ].
		^ 'Package: ', packageScope 
]

{ #category : 'internals' }
MicroUMLSDForPackageCode >> ast43BuildActors [
	packageScope ~= '' ifTrue: [	astBuilder , 'O' ].
	actions do: [ :actorClass | 
		astBuilder , actorClass name asString @ [ AIAPresenter onComment: actorClass comment]].
]

{ #category : 'internals' }
MicroUMLSDForPackageCode >> classNameCheck: aClass [
	packageScope 
		ifEmpty: [ ^ true ]
		ifNotEmpty: [  ^  aClass package name  = packageScope ].
]

{ #category : 'accessing' }
MicroUMLSDForPackageCode >> scope: scope [
	packageScope := scope 
]

{ #category : 'internals' }
MicroUMLSDForPackageCode >> umlSPFor: message [
	| idx cList subList nextPackage |
	idx := message fifth first.
	cList := message fifth second.
	subList := cList copyFrom: idx to: cList size.
	 nextPackage := message second package name.
	self class  
		forContext: subList 
		inScope: nextPackage
]
