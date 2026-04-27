Class {
	#name : 'MicroUMLSDForTagCode',
	#superclass : 'MicroUMLSDForCode',
	#instVars : [
		'packageScope',
		'tagScope'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'internals' }
MicroUMLSDForTagCode >> ast41Title [

		^ 'Package: ', packageScope , ' Tag: ', tagScope
]

{ #category : 'internals' }
MicroUMLSDForTagCode >> ast43BuildActors [
	astBuilder , 'O' .
	super ast43BuildActors.
]

{ #category : 'internals' }
MicroUMLSDForTagCode >> classNameCheck: aClass [
	(self emptyPackageTestFor: aClass)
		ifFalse: [ ^ false ]
		ifTrue: [
				packageScope := aClass package name.
				tagScope := aClass packageTag name.
				^ true ]
]

{ #category : 'internals' }
MicroUMLSDForTagCode >> emptyPackageTestFor: aClass [

	| test |
	test := aClass = self class or: [
		        (BlockClosure allSubclasses , { BlockClosure } includes: aClass) or: [
			        aClass = Context or: [ aClass = UndefinedObject ] ] ].
	^ test not
]

{ #category : 'internals' }
MicroUMLSDForTagCode >> openSubDiagramFor: message [
	
	|  cList subList nextPackage |
	cList := message fifth second.
	subList := cList 
		copyFrom: message fifth first 
		to: cList size.

	nextPackage := { message second package name.
		message second packageTag name }.
	self class 
		forContext: subList 
		inScope: nextPackage
]

{ #category : 'accessing' }
MicroUMLSDForTagCode >> scope: scope [
	packageScope := scope first.
	tagScope := scope second
]
