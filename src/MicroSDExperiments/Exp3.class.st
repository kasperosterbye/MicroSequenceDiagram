Class {
	#name : 'Exp3',
	#superclass : 'Object',
	#category : 'MicroSDExperiments-MicroURLMisc',
	#package : 'MicroSDExperiments',
	#tag : 'MicroURLMisc'
}

{ #category : 'as yet unclassified' }
Exp3 >> exp3Method1: foo [
	^ Exp4 new exp4method2: foo + 25.
]

{ #category : 'as yet unclassified' }
Exp3 >> exp3Method2 [
	^ Exp4 new exp4method1 + 25.
]
