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
	#name : 'MicroUMLSDMessages',
	#superclass : 'Object',
	#instVars : [
		'fromActor',
		'toActor',
		'description',
		'index',
		'clickAction',
		'messageType',
		'activation'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'accessing' }
MicroUMLSDMessages >> activation [
	^ activation 
]

{ #category : 'accessing' }
MicroUMLSDMessages >> activationOn [
	activation := true.
]

{ #category : 'accessing' }
MicroUMLSDMessages >> clickAction [
	"Returns the click action associated with the message"
	^ clickAction
]

{ #category : 'accessing' }
MicroUMLSDMessages >> clickAction: act [
	"Sets the click action for the message, which is executed when the message is clicked."
	clickAction := act
]

{ #category : 'accessing' }
MicroUMLSDMessages >> description [
	"Returns the description of the message"

	^ description
]

{ #category : 'accessing' }
MicroUMLSDMessages >> description: anObject [
	"Sets the description of the message"

	description := anObject
]

{ #category : 'accessing' }
MicroUMLSDMessages >> fromActor [
	"Returns the actor from which the message is sent"
	^ fromActor
]

{ #category : 'accessing' }
MicroUMLSDMessages >> fromActor: anObject [
	"Sets the actor from which the message is sent"
	fromActor := anObject
]

{ #category : 'accessing' }
MicroUMLSDMessages >> index [

	^ index
]

{ #category : 'accessing' }
MicroUMLSDMessages >> index: anObject [

	index := anObject
]

{ #category : 'initialization' }
MicroUMLSDMessages >> initialize [ 
	super initialize.
	activation := false.
]

{ #category : 'accessing' }
MicroUMLSDMessages >> messageType [
	"Returns the type of the message"

	^ messageType
]

{ #category : 'accessing' }
MicroUMLSDMessages >> messageType: anObject [
	"Sets the type of the message"

	messageType := anObject
]

{ #category : 'printing' }
MicroUMLSDMessages >> printOn: stream [
	"Prints the message in the format [sender -> receiver description (type)]"
	stream << '[ ' << fromActor name << ' -> ' << toActor name << ' ' << description asString
		<< ' (' << messageType asString << ') ]'
]

{ #category : 'accessing' }
MicroUMLSDMessages >> toActor [
	"Returns the actor to which the message is sent"

	^ toActor
]

{ #category : 'accessing' }
MicroUMLSDMessages >> toActor: anObject [
	"Sets the actor to which the message is sent"

	toActor := anObject
]
