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
		'lastMethod'
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

{ #category : 'accessing' }
MicroUMLSDrsMessages >> clickAction [
	"Returns the click action associated with the message"
	^ message clickAction
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> clickAction: act [
	"Sets the click action for the message, which is executed when the message is clicked."
	message clickAction: act
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> description [
	"Returns the description of the message"

	^ message description
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> description: anObject [
	"Sets the description of the message"

	message description: anObject
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> draw [
	"Draws a message line and label based on the message type and description"

	| line label |
	label := self drawLabel: message description at: message fromActor x + message toActor x / 2 @ (y - 10).
	"label := self drawLabel: description at: (fromActor x min: toActor x) @ (y - 10)."
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
MicroUMLSDrsMessages >> drawCall: line [
	"Draws a call message line with an arrowhead, adjusting the offset based on the positions of the sender and receiver actors."
    | offset |
    offset := (message fromActor x > message toActor x) ifTrue: [ 5 ] ifFalse: [ -5 ].
    line controlPoints: { message fromActor x @ y. (message toActor x + offset) @ y }
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
	"Draws a label at the given point splitting multiline text into separate positioned labels"
    | lines lineHeight lineAll|
    lines := aString lines.
    lines size <= 1 
		ifTrue: [
        lineAll :=  {RSLabel new text: aString; translateTo: aPoint; yourself}  ]
    	ifFalse: [
    lineHeight := 18.
    lineAll := lines collectWithIndex: [ :line :i |
        RSLabel new
            text: line;
            translateTo: aPoint x @ (aPoint y + ((i - 1) * lineHeight));
            yourself ]].
	^ lineAll 
]

{ #category : 'drawing' }
MicroUMLSDrsMessages >> drawReturn: line [
	"Draws a return message line with a dashed line and arrowhead, adjusting the offset based on the positions of the sender and receiver actors"
    | offset |
    offset := (message fromActor x > message toActor x) ifTrue: [ 5 ] ifFalse: [ -5 ].
    line 
        controlPoints: { message fromActor x @ y. (message toActor x + offset) @ y };
        dashArray: #(5 5)
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> fromActor [
	"Returns the actor from which the message is sent"

	^ message fromActor
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> fromActor: anObject [
	"Sets the actor from which the message is sent"
	message fromActor: anObject
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

{ #category : 'accessing' }
MicroUMLSDrsMessages >> messageType [
	"Returns the type of the message"

	^ message messageType
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> messageType: anObject [
	"Sets the type of the message"

	message messageType: anObject
]

{ #category : 'printing' }
MicroUMLSDrsMessages >> printOn: stream [
	"Prints the message in the format [sender -> receiver description (type)]"
	stream << '[ ' << message fromActor name << ' -> ' << message toActor name<< ' ' << message description asString
		<< ' (' << message messageType asString << ') ]'
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> toActor [
	"Returns the actor to which the message is sent"

	^ message toActor
]

{ #category : 'accessing' }
MicroUMLSDrsMessages >> toActor: anObject [
	"Sets the actor to which the message is sent"

	message toActor: anObject
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
