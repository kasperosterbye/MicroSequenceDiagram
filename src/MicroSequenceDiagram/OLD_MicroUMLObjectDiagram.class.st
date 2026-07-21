Class {
	#name : 'OLD_MicroUMLObjectDiagram',
	#superclass : 'Object',
	#instVars : [
		'instances',
		'relations',
		'grid',
		'canvas',
		'sizes'
	],
	#category : 'MicroSequenceDiagram-MicroUmlObjectDiagram',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUmlObjectDiagram'
}

{ #category : 'examples' }
OLD_MicroUMLObjectDiagram class >> example20 [

	self new example20.
]

{ #category : 'instance creation' }
OLD_MicroUMLObjectDiagram class >> fromInstancesAndRelations: iAndR [
	| instanse |
	instanse := self new.
	instanse instancesAndRelations: iAndR.
	^ instanse 
]

{ #category : 'as yet unclassified' }
OLD_MicroUMLObjectDiagram >> buildCell: text w: w [ 
    | box label |
    box := RSBox new
        width: w;
        height: (sizes at: #rowH);
        color: Color veryLightGray;
        border: (RSBorder new color: Color gray);
        yourself.
    label := RSLabel new text: text.
    ^ RSComposite new
        shapes: { box. label };
        yourself .
]

{ #category : 'roassal' }
OLD_MicroUMLObjectDiagram >> drawInsances [ 
	"Draws all actors on the canvas"
	canvas addAll: (instances collect: [ :actor | actor draw ])
]

{ #category : 'roassal' }
OLD_MicroUMLObjectDiagram >> drawRelations [
	"Draws all messages on the canvas"
    relations do: [ :msg | canvas addAll: msg draw ]
]

{ #category : 'examples' }
OLD_MicroUMLObjectDiagram >> example20 [

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
OLD_MicroUMLObjectDiagram >> example21 [

	| cells objects |
	canvas := RSCanvas new.
	grid := { 3. 3 }.
	objects := MicroUMLODObject build3x3.
	cells := (1 to: objects size) collect: [ :i |
			         RSComposite new
				         shapes: { self renderObject: (objects at: i) };
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
OLD_MicroUMLObjectDiagram >> gridX: x Y: y [
	grid := { x. y }
]

{ #category : 'initialization' }
OLD_MicroUMLObjectDiagram >> initialize [
	instances := OrderedCollection new.
	relations := OrderedCollection new.
	sizes := { #pad -> 8. #rowH -> 22 } asDictionary.
]

{ #category : 'accessing' }
OLD_MicroUMLObjectDiagram >> instancesAndRelations: iAndR [
	instances add: {#instance ->iAndR first. #x -> 0. #y ->0} asOrderedDictionary .
	"relations := iAndR second."
]

{ #category : 'as yet unclassified' }
OLD_MicroUMLObjectDiagram >> linkFromCells: cells cell: fromIx rowIndex: fromRow toCell: toIx [

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

{ #category : 'accessing' }
OLD_MicroUMLObjectDiagram >> maxWidth: pairs [

	| col1W col2W measure |
	measure := [ :s | (RSLabel new text: s) textWidth ].
	col1W := (pairs collect: [ :p | measure value: p first ]) max + (2 * (sizes at: #pad)).
	col2W := ((pairs collect: [ :p | measure value: p second ]) max) + (2*(sizes at: #pad)).
	^ {col1W. col2W }
]

{ #category : 'examples' }
OLD_MicroUMLObjectDiagram >> old2_renderObject: umlObject [
	"Renders a composite object with a title and key-value pairs for a given UML object."

| pairs pad rowH measure col1W col2W totalW  
  title cells rowIx object offset |
umlObject ifNil: [ ^ RSLabel new text: ''].
pairs := {umlObject fullName} , umlObject variables.
pad := sizes at: #pad. 
rowH := sizes at: #rowH.
measure := [ :s | (RSLabel new text: s) textWidth ].
col1W := ((pairs collect: [ :p | measure value: p first  ]) max) + (2*pad).
col2W := ((pairs collect: [ :p | measure value: p second ]) max) + (2*pad).
totalW := (col1W + col2W) max: (measure value: umlObject fullName) + (2*pad).
offset := (totalW - (col1W + col2W)) / 2.

cells := OrderedCollection new.
title := self buildCell: (umlObject fullName) w: totalW.
title translateTo: (totalW / 2) @ (rowH / 2).
cells add: title.

"Nøgle/værdi-rækker"
rowIx := 1.
pairs do: [ :p |
    | c1 c2 y |
    y := rowH * rowIx + (rowH / 2).
    c1 := self buildCell: p first  w: col1W.
    c2 := self buildCell: p second w: col2W.
	 c1 translateTo: (offset + (col1W / 2)) @ y.
	 c2 translateTo: (offset + col1W + (col2W / 2)) @ y.
    cells add: c1; add: c2.
    rowIx := rowIx + 1 ].

object := RSComposite new
    shapes: cells asArray;
    yourself.
^ object.
]

{ #category : 'examples' }
OLD_MicroUMLObjectDiagram >> old_renderObject: umlObject [
	"Renders a composite object with a title and key-value pairs for a given UML object."

| pairs pad rowH measure col1W col2W totalW buildCell 
  title cells rowIx object offset |
umlObject ifNil: [ ^ RSLabel new text: ''].
pairs := umlObject variables.
pad := 8. 
rowH := 22.

measure := [ :s | (RSLabel new text: s) textWidth ].
col1W := ((pairs collect: [ :p | measure value: p first  ]) max) + (2*pad).
col2W := ((pairs collect: [ :p | measure value: p second ]) max) + (2*pad).
"totalW := col1W + col2W."
totalW := (col1W + col2W) max: (measure value: umlObject fullName) + (2*pad).
offset := (totalW - (col1W + col2W)) / 2.

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
	 c1 translateTo: (offset + (col1W / 2)) @ y.
	 c2 translateTo: (offset + col1W + (col2W / 2)) @ y.
    cells add: c1; add: c2.
    rowIx := rowIx + 1 ].

object := RSComposite new
    shapes: cells asArray;
    yourself.
^ object.
]

{ #category : 'roassal' }
OLD_MicroUMLObjectDiagram >> renderDiagram [

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
OLD_MicroUMLObjectDiagram >> renderObject: umlObject [
	"Renders a composite object with a title and key-value pairs for a given UML object."

| pairs rowH measure cells rowIx offset |
umlObject ifNil: [ ^ RSLabel new text: ''].
pairs := { umlObject headerName } , umlObject variables.
rowH := sizes at: #rowH.
measure := self maxWidth: pairs.
offset := (measure first + measure second) / 2.

cells := OrderedCollection new.

rowIx := 1.
pairs do: [ :p |
    | c1 c2 y |
    y := rowH * rowIx + (rowH / 2).
    c1 := self buildCell: p first  w: measure first.
    c1 translateTo: (offset + (measure first / 2)) @ y.
	 c2 := self buildCell: p second w: measure second.
	 c2 translateTo: (offset + measure first + (measure second / 2)) @ y.
    cells add: c1; add: c2.
    rowIx := rowIx + 1 ].

^ RSComposite new
    shapes: cells asArray;
    yourself..
]

{ #category : 'examples' }
OLD_MicroUMLObjectDiagram >> rs2: id [

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
OLD_MicroUMLObjectDiagram >> rs2: idX at: umlObject [
	"Renders a composite object with a title and key-value pairs for a given UML object."

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
OLD_MicroUMLObjectDiagram >> rs3: id [

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
