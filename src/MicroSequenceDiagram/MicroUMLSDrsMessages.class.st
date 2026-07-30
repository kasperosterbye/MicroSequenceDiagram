"
# Class Comment for MicroUMLSDMessages

The `MicroUMLSDMessages` class is a fundamental component of the MicroUML framework, designed to represent and manage messages within sequence diagrams. This class encapsulates the properties and behaviours necessary to draw and interact with messages between actors in a sequence diagram, providing a visual representation of the interactions between different components of a system.

## Purpose and Role in the System

The primary purpose of the `MicroUMLSDMessages` class is to facilitate the creation and management of messages in sequence diagrams. It handles the drawing of message lines and labels, and manages the interactions between actors, such as sending and receiving messages. This class is crucial for visualising the flow of messages and interactions in a system, making it easier to understand the dynamics of the system.

## Main Collaborators or Dependencies

The `MicroUMLSDMessages` class collaborates closely with other classes in the MicroUML framework, particularly the `MicroUMLSDActor` class, which represents the actors in the sequence diagram. The `MicroUMLSDMessages` class relies on the `MicroUMLSDActor` class to determine the positions of the actors and to draw the message lines between them. Additionally, the `MicroUMLSDMessages` class uses the `RSCanvas` and `RSLabel` classes from the Roassal2 framework to draw the messages and labels on the canvas.

## Important Invariants or Design Constraints

One important invariant in the `MicroUMLSDMessages` class is the consistency between the positions of the actors and the messages. The positions of the actors must be correctly set before drawing the messages, as the message lines are drawn based on the positions of the actors. Another design constraint is the handling of different types of messages, such as call, return, and internal messages, each of which requires a different drawing method.

## Illustrative Usage Examples

### Example 1: Creating and Drawing a Message

```st
""Create a new message""
message := MicroUMLSDMessages new
    description: 'Request Data';
    fromActor: (MicroUMLSDActor new x: 50);
    toActor: (MicroUMLSDActor new x: 150);
    y: 100;
    messageType: #call;
    yourself.

""Draw the message""
canvas := RSCanvas new.
canvas addAll: message draw.
canvas open
```

This example demonstrates how to create a new message and draw it on a canvas. The `MicroUMLSDMessages` class is used to set the properties of the message, and the `draw` method is called to render the message on the canvas.

### Example 2: Handling Click Actions on Messages

```st
""Create a new message with a click action""
message := MicroUMLSDMessages new
    description: 'Request Data';
    fromActor: (MicroUMLSDActor new x: 50);
    toActor: (MicroUMLSDActor new x: 150);
    y: 100;
    messageType: #call;
    clickAction: [ :msg | Transcript show: 'Message clicked: ', msg description ];
    yourself.

""Draw the message""
canvas := RSCanvas new.
canvas addAll: message draw.
canvas open
```

In this example, a click action is associated with the message. When the message is clicked, the action is executed, which in this case prints a message to the Transcript. This demonstrates how to handle user interactions with messages in a sequence diagram.
"
Class {
	#name : 'MicroUMLSDrsMessages',
	#superclass : 'Object',
	#instVars : [
		'message',
		'y',
		'lastMethod',
		'activations'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'accessing' }
MicroUMLSDrsMessages class >> bottomMargin [
	"Returns the bottom margin for the sequence diagram"
    ^ 15
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
MicroUMLSDrsMessages >> draw [
	"Draws a message line and label based on the message type and description"

	| line label leftX |
self halt.
	leftX := message fromActor x min: message toActor x.
	label := self
   		drawLabel: message description
   		at: leftX @ (y - 10).
	message clickAction ifNotNil: [
			label first color: Color red.
			label first italic.
			label first when: RSMouseClick do: [ :evt | message clickAction value ] for: self ].
	line := RSPolyline new
		        color: Color black;
		        markerEnd: (RSShapeFactory arrow
				         size: 10;
				         color: Color black) asMarker;
		        yourself.
	message messageType = #call ifTrue: [ self drawCall: line ].
	message messageType = #return ifTrue: [ self drawReturn: line ].
	message messageType = #internal ifTrue: [ self drawInternal: line ].

	^ { line } , label
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> draw: activationLevels [

	| line label direction activationWidth levelOffset
	  fromCenterX toCenterX startX endX labelX fromLevel toLevel |

	activationWidth := 10.
	levelOffset := activationWidth / 2.

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
		at: labelX @ (y - 10).

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
				startX @ y.
				endX @ y }.

			message messageType = #return ifTrue: [
				line dashArray: #(5 5) ] ].

	^ { line } , label
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> drawCall: line [
	"Draws a call message line with an arrowhead, adjusting the offset based on the positions of the sender and receiver actors."
    | offset |
self halt.
    offset := (message fromActor x > message toActor x) ifTrue: [ 5 ] ifFalse: [ -5 ].
    line controlPoints: { message fromActor x @ y . (message toActor x + offset)  @ y }
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> drawCall: line from: a to: b [
	| leftToRight |
	leftToRight := (message fromActor x <= message toActor x). "ifTrue: [ 5 ] ifFalse: [ -5 ]"
	leftToRight 
		ifTrue: [ line controlPoints: 
			{ message fromActor x + (a*15) @ y . 
			( message toActor x - (b*15) - 5 )  @ y } ]
		ifFalse: [ line controlPoints: 
			{ message fromActor x + (a*15) @ y . 
			(message toActor x + (b*15) + 5)  @ y } ]
    
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
	"Draws a label with all lines left-aligned at aPoint x"

	| lines lineHeight |

	lines := aString lines.
	lineHeight := 18.

	^ lines collectWithIndex: [ :line :i |
		| label |
		label := RSLabel new text: line.
		label translateTo:
			(aPoint x + (label textWidth / 2) + 10)
			@
			(aPoint y + ((i - 1) * lineHeight)).
		label ]
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> drawReturn: line [
	"Draws a return message line with a dashed line and arrowhead, adjusting the offset based on the positions of the sender and receiver actors"
    | offset |
self halt.
    offset := (message fromActor x > message toActor x) ifTrue: [ 5 ] ifFalse: [ -5 ].
    line 
        controlPoints: { message fromActor x @ y. (message toActor x + offset) @ y };
        dashArray: #(5 5)
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> drawReturn: line from: a to: b [
	| leftToRight |
	leftToRight := (message fromActor x <= message toActor x). "ifTrue: [ 5 ] ifFalse: [ -5 ]"
	leftToRight 
	   ifTrue: [ line controlPoints: 
			{ message fromActor x + (a*15) @ y . 
			( message toActor x - (b*15) - 5 )  @ y }   ]
		ifFalse: [ line controlPoints: 
			{ message fromActor x - (a*15) @ y . 
			(message toActor x +  (b*15) + 5)  @ y } ].
    line dashArray: #(5 5)
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> draw_old: activationLevels [
	"Draws a message line and label based on the message type and description"

	| line label leftX rightX am1 am2 |
	activations := activationLevels.
	am1 := activations at: { message fromActor actor index. message index }.
	am2 := activations at: { message toActor actor index. message index }.
	leftX := message fromActor x min: message toActor x.
	rightX :=  message fromActor x max: message toActor x.
	label := self
   		drawLabel: message description
   		at: leftX + ( am1 * 5 ) @ (y - 10).
	message clickAction ifNotNil: [
			label first color: Color red.
			label first italic.
			label first when: RSMouseClick do: [ :evt | message clickAction value ] for: self ].
	line := RSPolyline new
		        color: Color black;
		        markerEnd: (RSShapeFactory arrow
				         size: 10;
				         color: Color black) asMarker;
		        yourself.
	message messageType = #call ifTrue: [ self drawCall: line from: am1 to: am2 ].
	message messageType = #return ifTrue: [ self drawReturn: line from: am1 to: am2 ].
	message messageType = #internal ifTrue: [ self drawInternal: line ].

	^ { line } , label
]

{ #category : 'initialization' }
MicroUMLSDrsMessages >> initialize [ 
	super initialize.
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> lastMethod: meth [
	"Sets the last method associated with the message"
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
	stream << '[ ' << message fromActor name << ' -> ' << message toActor name<< ' ' << message description asString
		<< ' (' << message messageType asString << ') ]'
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
