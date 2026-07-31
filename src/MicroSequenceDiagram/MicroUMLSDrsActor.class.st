Class {
	#name : 'MicroUMLSDrsActor',
	#superclass : 'Object',
	#instVars : [
		'actor',
		'width',
		'x'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'accessing' }
MicroUMLSDrsActor class >> actorGap [
	"Returns the gap between actors in a sequence diagram"
    ^ 20 
]

{ #category : 'accessing' }
MicroUMLSDrsActor class >> boxHeight [
	"Returns the height of the box in a sequence diagram"
    ^ 40
]

{ #category : 'accessing' }
MicroUMLSDrsActor class >> boxPadding [
	"Returns the padding for the box in a sequence diagram"
    ^ 10 
]

{ #category : 'accessing' }
MicroUMLSDrsActor >> actor [

	^ actor
]

{ #category : 'accessing' }
MicroUMLSDrsActor >> actor: anObject [

	actor := anObject
]

{ #category : 'drawing' }
MicroUMLSDrsActor >> draw [
	"Draws an actor element with a box and label, positioned at the specified x-coordinate"
	| actorElement |
	actorElement := RSComposite new.
	actorElement shapes: { self drawBox. self drawLabel }.
	actorElement translateTo: x @ 0.
	^ actorElement
]

{ #category : 'drawing' }
MicroUMLSDrsActor >> drawBox [
	^ RSBox new
		       width: self width;
		       height: self class boxHeight;
		       color: Color veryLightGray;
		       borderColor: Color veryDarkGray.
]

{ #category : 'drawing' }
MicroUMLSDrsActor >> drawLabel [
	| label |
	label := RSLabel new text: self actor name.
	actor clickAction ifNotNil: [
		label color: Color red.
		label italic.
		label when: RSMouseClick do: [ :evt | actor clickAction value ] for: self ].
	^ label
]

{ #category : 'printing' }
MicroUMLSDrsActor >> printOn: stream [
	"Prints the actor's name in the format 'Actor: name'"
	stream << 'Actor: ' << actor name asString
]

{ #category : 'accessing' }
MicroUMLSDrsActor >> width [
	"Sets the width of the actor and calculates it based on the label text"
	width ifNil: [ width := (RSLabel new text: self actor name) textWidth + (self class boxPadding * 2) ].
	^ width
]

{ #category : 'accessing' }
MicroUMLSDrsActor >> x [
	"Returns the x-coordinate of the actor"

	^ x
]

{ #category : 'accessing' }
MicroUMLSDrsActor >> x: anObject [
	"Sets the x-coordinate of the actor"

	x := anObject
]
