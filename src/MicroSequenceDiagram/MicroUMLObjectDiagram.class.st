Class {
	#name : 'MicroUMLObjectDiagram',
	#superclass : 'Object',
	#instVars : [
		'instances',
		'relations',
		'grid',
		'canvas'
	],
	#category : 'MicroSequenceDiagram-MicroUmlObjectDiagram',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUmlObjectDiagram'
}

{ #category : 'examples' }
MicroUMLObjectDiagram class >> example20 [

	self new example20.
]

{ #category : 'instance creation' }
MicroUMLObjectDiagram class >> fromInstancesAndRelations: iAndR [
	| instanse |
	instanse := self new.
	instanse instancesAndRelations: iAndR.
	^ instanse 
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawInsances [ 
	"Draws all actors on the canvas"
	canvas addAll: (instances collect: [ :actor | actor draw ])
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> drawRelations [
	"Draws all messages on the canvas"
    relations do: [ :msg | canvas addAll: msg draw ]
]

{ #category : 'examples' }
MicroUMLObjectDiagram >> example20 [

	| noOfClells cells |
	Transcript showCr: 'example20'.
	canvas := RSCanvas new.
	grid := { 3. 3 }.
	noOfClells := grid first * grid second.
	cells := (1 to: noOfClells) collect: [ :i |
			         | label |
			         label := i odd
				                  ifTrue: [
						                  ({ 3. 7 } includes: i)
							                  ifTrue: [ self rs2: i ]
							                  ifFalse: [ self rs3: i ] ]
				                  ifFalse: [ RSLabel new text: '' ].

			         RSComposite new
				         shapes: { label };
				         model: i;
				         yourself ].
	canvas addAll: cells.
	RSGridLayout new
		lineItemsCount: 3;
		gapSize: 50;
		on: cells.
	canvas add: (self
			 linkFromCells: cells
			 cell: 3 rowIndex: 2
			 toCell: 9).
	canvas add: (self
			 linkFromCells: cells
			 cell: 3 rowIndex: 1
			 toCell: 5).
	canvas @ RSCanvasController.
	canvas open
]

{ #category : 'examples' }
MicroUMLObjectDiagram >> example21 [

	| cells objects |
	canvas := RSCanvas new.
	grid := { 3. 3 }.
	objects := MicroUMLODObject build3x3.
	cells := (1 to: objects size) collect: [ :i |
			         RSComposite new
				         shapes: { self rs2: i at: (objects at: i) };
				         model: i;
				         yourself ].
	canvas addAll: cells.
	RSGridLayout new
		lineItemsCount: 3;
		gapSize: 50;
		on: cells.
	canvas add: (self
			 linkFromCells: cells
			 cell: 3 rowIndex: 2
			 toCell: 9).
	canvas @ RSCanvasController.
	canvas open
]

{ #category : 'as yet unclassified' }
MicroUMLObjectDiagram >> gridX: x Y: y [
	grid := { x. y }
]

{ #category : 'initialization' }
MicroUMLObjectDiagram >> initialize [
	instances := OrderedCollection new.
	relations := OrderedCollection new.
]

{ #category : 'accessing' }
MicroUMLObjectDiagram >> instancesAndRelations: iAndR [
	instances add: {#instance ->iAndR first. #x -> 0. #y ->0} asOrderedDictionary .
	"relations := iAndR second."
]

{ #category : 'as yet unclassified' }
MicroUMLObjectDiagram >> linkFromCells: cells cell: fromIx rowIndex: fromRow toCell: toIx [

	| rowH gapSize fromRect toRect diff x1 y1 x2 y2 xOut |
	rowH := 22.
	gapSize := 50.
	fromRect := (cells at: fromIx) encompassingRectangle.
	toRect := (cells at: toIx) encompassingRectangle.
	diff := (cells at: fromIx) matrix x - (cells at: toIx) matrix x.
	diff negative ifTrue: [ x1 := fromRect right. x2 := toRect left ].
	diff positive ifTrue: [ x1 := fromRect left. x2 := toRect right ].
	diff isZero ifTrue: [ x1 := fromRect right. x2 := toRect right ].

	y1 := fromRect top + (rowH * (fromRow + 0.5)).
	y2 := toRect top + (rowH * 0.5).
	xOut := diff <= 0 ifTrue: [ x1 + (gapSize/2) ] ifFalse: [ x1 - (gapSize/2) ].
	^ RSBezier "RSPolyline" new
		  controlPoints: { (x1 @ y1). (xOut @ y1). (xOut @ y2). (x2 @ y2) };
		  color: Color black;
		  markerEnd: (RSShapeFactory arrow
				   size: 8;
				   color: Color black) asMarker;
		  yourself
]

{ #category : 'roassal' }
MicroUMLObjectDiagram >> renderDiagram [

	canvas := RSCanvas new.
	self 
		computeInstancePositions;
		"computeMessagePositions;"
		drawInsances";
		drawLifelines;
		drawMessages".
	canvas @ RSCanvasController.
	canvas openWithTitle: 'Object Diagram'
]

{ #category : 'examples' }
MicroUMLObjectDiagram >> rs2: id [

| pairs pad rowH measure col1W col2W totalW buildCell 
  title cells rowIx object |
pairs := #(#('UK' 'London') #('USA' 'Washington') #('Germany' 'Berlin')).
pad := 8. 
rowH := 22.

measure := [ :s | (RSLabel new text: s) textWidth ].
col1W := ((pairs collect: [ :p | measure value: p first  ]) max) + (2*pad).
col2W := ((pairs collect: [ :p | measure value: p second ]) max) + (2*pad).
totalW := col1W + col2W.

buildCell := [ :text :w |
    | box label |
    box := RSBox new
        width: w;
        height: rowH;
        color: Color veryLightGray;
        border: (RSBorder new color: Color gray);
        yourself.
    label := RSLabel new text: text.
    RSComposite new
        shapes: { box. label };
        yourself ].

cells := OrderedCollection new.

"Titel spænder over begge kolonner"
title := buildCell value: ('CapitalCity' , id asString) value: totalW.
title translateTo: (totalW / 2) @ (rowH / 2).
cells add: title.

"Nøgle/værdi-rækker"
rowIx := 1.
pairs do: [ :p |
    | c1 c2 y |
    y := rowH * rowIx + (rowH / 2).
    c1 := buildCell value: p first  value: col1W.
    c2 := buildCell value: p second value: col2W.
    c1 translateTo: (col1W / 2) @ y.
    c2 translateTo: (col1W + (col2W / 2)) @ y.
    cells add: c1; add: c2.
    rowIx := rowIx + 1 ].

object := RSComposite new
    shapes: cells asArray;
    yourself.
^ object.

]

{ #category : 'examples' }
MicroUMLObjectDiagram >> rs2: id at: umlObject [

| pairs pad rowH measure col1W col2W totalW buildCell 
  title cells rowIx object |
umlObject ifNil: [ ^ RSLabel new text: ''].
pairs := umlObject variables.
pad := 8. 
rowH := 22.

measure := [ :s | (RSLabel new text: s) textWidth ].
col1W := ((pairs collect: [ :p | measure value: p first  ]) max) + (2*pad).
col2W := ((pairs collect: [ :p | measure value: p second ]) max) + (2*pad).
totalW := col1W + col2W.

buildCell := [ :text :w |
    | box label |
    box := RSBox new
        width: w;
        height: rowH;
        color: Color veryLightGray;
        border: (RSBorder new color: Color gray);
        yourself.
    label := RSLabel new text: text.
    RSComposite new
        shapes: { box. label };
        yourself ].

cells := OrderedCollection new.

"Titel spænder over begge kolonner"
"title := buildCell value: ('CapitalCity' , id asString) value: totalW."
title := buildCell value: (umlObject fullName) value: totalW.
title translateTo: (totalW / 2) @ (rowH / 2).
cells add: title.

"Nøgle/værdi-rækker"
rowIx := 1.
pairs do: [ :p |
    | c1 c2 y |
    y := rowH * rowIx + (rowH / 2).
    c1 := buildCell value: p first  value: col1W.
    c2 := buildCell value: p second value: col2W.
    c1 translateTo: (col1W / 2) @ y.
    c2 translateTo: (col1W + (col2W / 2)) @ y.
    cells add: c1; add: c2.
    rowIx := rowIx + 1 ].

object := RSComposite new
    shapes: cells asArray;
    yourself.
^ object.

]

{ #category : 'examples' }
MicroUMLObjectDiagram >> rs3: id [

| pairs pad rowH measure col1W col2W totalW buildCell 
  title cells rowIx object |
pairs := #(#('UK' 'London') #('USA' 'Washington')).
pad := 8. 
rowH := 22.

measure := [ :s | (RSLabel new text: s) textWidth ].
col1W := ((pairs collect: [ :p | measure value: p first  ]) max) + (2*pad).
col2W := ((pairs collect: [ :p | measure value: p second ]) max) + (2*pad).
totalW := col1W + col2W.

buildCell := [ :text :w |
    | box label |
    box := RSBox new
        width: w;
        height: rowH;
        color: Color veryLightGray;
        border: (RSBorder new color: Color gray);
        yourself.
    label := RSLabel new text: text.
    RSComposite new
        shapes: { box. label };
        yourself ].

cells := OrderedCollection new.

"Titel spænder over begge kolonner"
title := buildCell value: ('CapitalCity' , id asString) value: totalW.
title translateTo: (totalW / 2) @ (rowH / 2).
cells add: title.

"Nøgle/værdi-rækker"
rowIx := 1.
pairs do: [ :p |
    | c1 c2 y |
    y := rowH * rowIx + (rowH / 2).
    c1 := buildCell value: p first  value: col1W.
    c2 := buildCell value: p second value: col2W.
    c1 translateTo: (col1W / 2) @ y.
    c2 translateTo: (col1W + (col2W / 2)) @ y.
    cells add: c1; add: c2.
    rowIx := rowIx + 1 ].

object := RSComposite new
    shapes: cells asArray;
    yourself.
^ object.

]
