Class {
	#name : 'Bexp',
	#superclass : 'Object',
	#instVars : [
		'aaa',
		'bbb'
	],
	#category : 'MicroSDExperiments-MicroURLMisc',
	#package : 'MicroSDExperiments',
	#tag : 'MicroURLMisc'
}

{ #category : 'accessing' }
Bexp >> first: arg [
| temp |
temp := arg * 2.
thisContext copy inspect.
^ temp
]
