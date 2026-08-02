Class {
	#name : 'MicroUMLSDrsMessages',
	#superclass : 'Object',
	#instVars : [
		'message',
		'y',
		'lastMethod'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'as yet unclassified' }
MicroUMLSDrsMessages class >> activationOffset [
	^ 5
]

{ #category : 'accessing' }
MicroUMLSDrsMessages class >> bottomMargin [
	"Returns the bottom margin for the sequence diagram"
    ^ 15
]

{ #category : 'as yet unclassified' }
MicroUMLSDrsMessages class >> labelLineHeight [
	^ 18
]

{ #category : 'accessing' }
MicroUMLSDrsMessages class >> messageGap [
	"Returns the gap between messages in the sequence diagram"
    ^ 40
]

{ #category : 'accessing' }
MicroUMLSDrsMessages class >> topMargin [
	"Returns the top margin for the sequence diagram"
    ^ 15
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> draw: activationLevels [

	| activationOffset labelPadding fromLevel toLevel direction
	  fromCenterX toCenterX startX endX messageIsInternal labelX label line  |
	activationOffset := activationOffset := self class activationOffset.
	labelPadding := 5.
	fromLevel := activationLevels at: {
		message fromActor actor index.
		message index }.

	toLevel := activationLevels at: {
		message toActor actor index.
		message index }.

	direction := message toActor x > message fromActor x
		ifTrue: [ 1 ]
		ifFalse: [ -1 ].

	fromCenterX := fromLevel isZero
		ifTrue: [ message fromActor x ]
		ifFalse: [
			message fromActor x
				+ ((fromLevel - 1) * activationOffset) ].

	toCenterX := toLevel isZero
		ifTrue: [ message toActor x ]
		ifFalse: [
			message toActor x
				+ ((toLevel - 1) * activationOffset) ].

	startX := fromLevel isZero
		ifTrue: [ fromCenterX ]
		ifFalse: [
			fromCenterX + (direction * activationOffset) ].

	endX := toLevel isZero
		ifTrue: [ toCenterX ]
		ifFalse: [
			toCenterX - (direction * activationOffset) ].
	messageIsInternal := message messageType = #internal.
	messageIsInternal ifFalse: [
		endX := endX - (direction * activationOffset) ].

	labelX := (startX min: endX) + labelPadding.

	label := self
		drawLabel: message description
		at: labelX @ (y - 10).

	self setClickActionOn: label .

	line := self rsPolyline.

	messageIsInternal 	
		ifFalse: [
			line controlPoints: {
				startX @ y.
				endX @ y }.

			message messageType = #return ifTrue: [
				line dashArray: #(5 5) ]]
		ifTrue: [
			self drawInternal: line ].

	^ { line } , label
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> drawInternal: line [
	"Draws an internal message line with a loopback shape, adjusting the offset based on the positions of the sender and receiver actors."
    | x |
    x := message fromActor x.
    line controlPoints: { 
        x @ y. 
        (x + 25) @ y. 
        (x + 25) @ (y + 15). 
        (x + 5) @ (y + 15) 
    }
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> drawLabel: aString at: aPoint [
	
	^ aString lines collectWithIndex: [ :line :i |
		| label |
		label := RSLabel new text: line.
		label translateTo:
			(aPoint x + (label textWidth / 2) + 10)
			@
			(aPoint y + ((i - 1) * self class labelLineHeight)).
		label ]
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> lastMethod: meth [
	"Sets the last method associated with the message"
	self error: 'Chenge caller so this method is not called'.
	lastMethod := meth
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> message [

	^ message
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> message: anObject [
	message := anObject
]

{ #category : 'printing' }
MicroUMLSDrsMessages >> printOn: stream [
	"Prints the message in the format [sender -> receiver description (type)]"
	stream 
		<< '[ ' << message fromActor actor name << ' -> ' << message toActor actor name
		<< ' ' << message description asString
		<< ' (' << message messageType asString << ') ]'
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> rsPolyline [ 
	^ RSPolyline new
		color: Color black;
		markerEnd: (RSShapeFactory arrow
			size: 10;
			color: Color black) asMarker;
		yourself.
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> setClickActionOn: label [ 
	message clickAction ifNotNil: [
		label first
			color: Color red;
			italic;
			when: RSMouseClick
			do: [ :event | message clickAction value ]
			for: self ].
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> y [
	"Returns the y-coordinate of the message"

	^ y
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> y: anObject [
	"Sets the y-coordinate of the message in the sequence diagram"
	y := anObject
]
