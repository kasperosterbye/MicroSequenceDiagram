Class {
	#name : 'MicroUMLSDrsMessagesDraw',
	#superclass : 'Object',
	#instVars : [
		'rsMessage',
		'activationLevels',
		'message',
		'fromLevel',
		'toLevel',
		'direction'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'as yet unclassified' }
MicroUMLSDrsMessagesDraw class >> labelLineHeight [
	^ 18
]

{ #category : 'as yet unclassified' }
MicroUMLSDrsMessagesDraw >> activationWidth [ 
	^ 10.
]

{ #category : 'drawing' }
MicroUMLSDrsMessagesDraw >> draw [

	| line label  activationWidth levelOffset
	  fromCenterX toCenterX startX endX labelX   |
	levelOffset := self activationWidth / 2.

	fromLevel := activationLevels at: {
		message fromActor actor index.
		message index }.
	toLevel := activationLevels at: {
		message toActor actor index.
		message index }.

	direction := message toActor x > message fromActor x
		ifTrue: [ 1 ]
		ifFalse: [ -1 ].

	fromCenterX := fromLevel = 0
		ifTrue: [ message fromActor x ]
		ifFalse: [
			message fromActor x
				+ ((fromLevel - 1) * levelOffset) ].

	toCenterX := toLevel = 0
		ifTrue: [ message toActor x ]
		ifFalse: [
			message toActor x
				+ ((toLevel - 1) * levelOffset) ].

	startX := fromLevel = 0
		ifTrue: [ fromCenterX ]
		ifFalse: [
			fromCenterX + (direction * activationWidth / 2) ].

	endX := toLevel = 0
		ifTrue: [ toCenterX ]
		ifFalse: [
			toCenterX - (direction * activationWidth / 2) ].
	message messageType = #return ifTrue: [
		endX := endX - (direction * 5) ].

	labelX := (startX min: endX) + 5.

	label := self
		drawLabel: message description
		at: labelX @ (rsMessage y - 10).

	message clickAction ifNotNil: [
		label first
			color: Color red;
			italic;
			when: RSMouseClick
			do: [ :event | message clickAction value ]
			for: self ].

	line := RSPolyline new
		color: Color black;
		markerEnd: (RSShapeFactory arrow
			size: 10;
			color: Color black) asMarker;
		yourself.

	message messageType = #internal
		ifTrue: [
			self drawInternal: line ]
		ifFalse: [
			line controlPoints: {
				startX @ rsMessage y.
				endX @ rsMessage y }.

			message messageType = #return ifTrue: [
				line dashArray: #(5 5) ] ].

	^ { line } , label
]

{ #category : 'drawing' }
MicroUMLSDrsMessagesDraw >> drawLabel: aString at: aPoint [
	
	^ aString lines collectWithIndex: [ :line :i |
		| label |
		label := RSLabel new text: line.
		label translateTo:
			(aPoint x + (label textWidth / 2) + 10)
			@
			(aPoint y + ((i - 1) * self class labelLineHeight)).
		label ]
]

{ #category : 'as yet unclassified' }
MicroUMLSDrsMessagesDraw >> on: rs activationLevels: al [
	rsMessage := rs.
	activationLevels := al.
	message := rsMessage message.
	^ self
]
