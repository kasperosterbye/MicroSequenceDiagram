"
# `MicroUMLSequenceDiagram` — Class Comment

## Overview

`MicroUMLSequenceDiagram` is the central class in the MicroSequenceDiagram package, responsible for constructing, laying out, and rendering UML sequence diagrams using the Roassal visualisation framework. It models the temporal flow of interactions between participants (actors) in a system, visualising message exchanges over time in a clear, interactive diagram.

The class serves as both a model and a builder: it holds collections of actors and messages, computes their spatial positions according to layout heuristics, and assembles a complete Roassal canvas that can be opened as an interactive window. It is designed for rapid prototyping of sequence diagrams directly within Pharo, particularly useful in exploratory programming, documentation generation, debugging sessions, or architectural reviews where visualising call flows adds immediate value.

## Main Collaborators and Dependencies

- **`MicroUMLSDActor`**: Represents each participant in the diagram. Instances hold names, positions, widths, and drawing logic (box + label). The diagram computes horizontal spacing between actors based on the widest message between each pair.
- **`MicroUMLSDMessages`**: Encapsulates individual messages, including description, sender/receiver actors, type (`#call`, `#return`, or `#internal`), vertical position, and optional click actions. It provides the drawing logic for arrows, dashed return lines, self-loops, and multiline labels.
- **Roassal (`RSCanvas`, `RSLine`, `RSLabel`, `RSComposite`, `RSCanvasController`)**: The underlying canvas and shape library used for all rendering. The diagram adds shapes directly to the canvas and installs interaction controllers for zooming, panning, and mouse events.
- **Constants from collaborators**: Relies on class-side constants such as `MicroUMLSDActor>>#actorGap`, `MicroUMLSDActor>>#boxHeight`, `MicroUMLSDMessages>>#messageGap`, `MicroUMLSDMessages>>#topMargin`, and `MicroUMLSDMessages>>#bottomMargin` to ensure consistent layout.

No external file I/O or persistence is provided; the diagram is built in memory and rendered on demand.

## Important Invariants and Design Constraints

- **Ordering and uniqueness**: Actors must be supplied in left-to-right order. The first actor is always positioned at `actorGap`; subsequent positions are derived incrementally. Messages must reference exactly these actor instances (identity equality is used in `computeActorPositions`).
- **Layout heuristics**: Horizontal spacing between adjacent actors is the maximum of:
  - A fixed `actorGap`.
  - The pixel width of the widest label for messages exchanged directly between that pair, plus padding.
  - Half the combined widths of the two actor boxes plus two gaps (to prevent overlap).
  Vertical message positions are strictly sequential with a fixed `messageGap`, independent of message content.
- **Lifeline length**: The dashed lifelines are drawn once after actor positions are known; their height is computed from the number of messages plus fixed top and bottom margins. Adding messages after `renderDiagram` has been called will not automatically extend lifelines.
- **Message types**: Only `#call` (solid arrow), `#return` (dashed arrow), and `#internal` (self-loop) are supported in drawing. Other values silently produce a plain line.
- **Mutability**: The diagram is mutable after initialisation. `actorsAndMessages:` replaces the collections; subsequent calls to `renderDiagram` will reflect the latest state. Click actions can be attached to actors or messages for interactive behaviour (e.g., opening inspectors or navigating to source code).
- **Performance**: Layout is O(n²) in the worst case (scanning all messages for each actor pair) but is intended for small-to-medium diagrams (tens of actors, low hundreds of messages). No caching of label widths is performed.
- **Error handling**: Minimal; incorrect actor references or negative positions will simply produce malformed diagrams rather than raising domain-specific exceptions.

The class deliberately separates concerns: position computation, drawing, and canvas management are distinct methods, facilitating subclassing or extension (e.g., for different layout algorithms or export formats).

## Usage

Create an instance, populate it with actors and messages (optionally attaching click actions), then send `renderDiagram` to open the interactive window. The diagram is typically built once and discarded; for repeated use, create fresh instances or reset the collections.

### Example 1: Basic Sequence Diagram (Static View)

```smalltalk
| diagram actorA actorB msg1 msg2 |
actorA := MicroUMLSDActor new name: 'Client'.
actorB := MicroUMLSDActor new name: 'Server'.

msg1 := MicroUMLSDMessages new
    description: 'getData()';
    fromActor: actorA;
    toActor: actorB;
    messageType: #call;
    yourself.

msg2 := MicroUMLSDMessages new
    description: 'data';
    fromActor: actorB;
    toActor: actorA;
    messageType: #return;
    yourself.

diagram := MicroUMLSequenceDiagram fromActorsAndMessages: {
    { actorA. actorB }.
    { msg1. msg2 }
}.

diagram uiTitle: 'Client–Server Interaction'.
diagram renderDiagram
```

This produces a two-actor diagram with a call and its return, automatically spaced according to label widths.

### Example 2: Interactive Diagram with Click Actions

```smalltalk
| diagram user db queryMsg responseMsg |
user := MicroUMLSDActor new
    name: 'User';
    clickAction: [ Transcript show: 'User clicked'; cr ].

db := MicroUMLSDActor new
    name: 'Database';
    clickAction: [ self inspect ].

queryMsg := MicroUMLSDMessages new
    description: 'SELECT * FROM orders';
    fromActor: user;
    toActor: db;
    messageType: #call;
    clickAction: [ :msg | msg lastMethod ifNotNil: [ :m | m browse ] ];
    lastMethod: thisContext method;
    yourself.

responseMsg := MicroUMLSDMessages new
    description: 'ResultSet (42 rows)';
    fromActor: db;
    toActor: user;
    messageType: #return;
    yourself.

diagram := MicroUMLSequenceDiagram new.
diagram actorsAndMessages: { { user. db }. { queryMsg. responseMsg } }.
diagram uiTitle: 'Interactive Query Flow'.
diagram renderDiagram
```

Clicking actors or messages triggers the registered blocks, enabling navigation from the diagram into live code or data. This pattern is especially powerful when the diagram is generated from an actual execution trace.

In both cases the diagram computes positions on the fly, draws actors at the top, dashed lifelines beneath them, and messages at increasing vertical offsets. The resulting canvas supports standard Roassal interactions. For more complex scenarios, subclass `MicroUMLSequenceDiagram` and override `computeActorPositions` or `drawMessages` to introduce domain-specific layout rules.
"
Class {
	#name : 'MicroUMLObjectDiagram',
	#superclass : 'Object',
	#instVars : [
		'instances',
		'relations',
		'canvas',
		'uiTitle'
	],
	#category : 'MicroSequenceDiagram-MicroUmlObjectDiagram',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUmlObjectDiagram'
}

{ #category : 'instance creation' }
MicroUMLObjectDiagram class >> fromActorsAndMessages: aAndM [
	| instanse |
	instanse := self new.
	instanse actorsAndMessages: aAndM.
	^ instanse
]

{ #category : 'instance creation' }
MicroUMLObjectDiagram class >> fromInstancesAndRelations: iAndR [
	| instanse |
	instanse := self new.
	instanse instancesAndRelations: iAndR.
	^ instanse 
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> computeActorPositions [
	"Computes the horizontal positions of actors based on message distances"

	| actorGap maxDistance |
	actorGap := MicroUMLSDActor actorGap.
	actors first x: actorGap.
	2 to: actors size do: [ :index |
			| a b messagesBetween |
			a := actors at: index -1.
			b := actors at: index .

			messagesBetween := messages select: [ :msg |
				(msg fromActor = a and: [ msg toActor = b ]) or: [ msg fromActor = b and: [ msg toActor = a ] ] ].
			maxDistance := messagesBetween
				 ifEmpty: [ actorGap ]
				 ifNotEmpty: [ :msgs | 
				 	(msgs collect: [ :msg | (RSLabel new text: msg description) textWidth ]) max + actorGap + 10].
			b x: a x + (maxDistance max: (a width / 2) + (b width / 2) + (2*actorGap) )   ].
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> computeMessagePositions [
	"Computes the vertical positions of messages based on their order and a fixed gap"
    relations doWithIndex: [ :msg :i |
        msg y: MicroUMLSDMessages topMargin + (i * MicroUMLSDMessages messageGap) ]
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawActors [
	"Draws all actors on the canvas"
	canvas addAll: (actors collect: [ :actor | actor draw ])
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawInsances [
	canvas addAll: (instances collect: [ :actor | actor draw ])
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawLifelines [
	"Draws the lifelines for each actor on the canvas"
    canvas addAll: (actors collect: [ :actor |
        RSLine new
            startPoint: actor x @ (MicroUMLSDActor boxHeight / 2);
            endPoint: actor x @ (MicroUMLSDActor boxHeight / 2 + self lifelineHeight);
            dashArray: #(5 5);
            color: Color black;
            yourself ])
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawMessages [
	"Draws all messages on the canvas"
    messages do: [ :msg | canvas addAll: msg draw ]
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawRelations [
	"Draws all messages on the canvas"
    relations do: [ :msg | canvas addAll: msg draw ]
]

{ #category : 'initialization' }
MicroUMLObjectDiagram >> initialize [
	instances := OrderedCollection new.
	relations := OrderedCollection new.
	uiTitle := 'Object Diagram'.
]

{ #category : 'accessing' }
MicroUMLObjectDiagram >> instancesAndRelations: iAndR [
	instances := iAndR first.
	relations := iAndR second.
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> lifelineHeight [
	"Returns the total height of the lifeline based on the number of messages and fixed margins"
	
    ^ MicroUMLSDMessages topMargin 
        + (messages size * MicroUMLSDMessages messageGap) 
        + MicroUMLSDMessages bottomMargin
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> renderDiagram [

	canvas := RSCanvas new.
	self 
		computeActorPositions;
		computeMessagePositions;
		drawActors;
		drawLifelines;
		drawMessages.
	canvas @ RSCanvasController.
	canvas openWithTitle: uiTitle
]

{ #category : 'accessing' }
MicroUMLObjectDiagram >> uiTitle: title [
	"Sets the title of the sequence diagram"
	uiTitle := title.
]
