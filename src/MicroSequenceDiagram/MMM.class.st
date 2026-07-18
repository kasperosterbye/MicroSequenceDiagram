Class {
	#name : 'MMM',
	#superclass : 'Object',
	#category : 'MicroSequenceDiagram-MicroUmlObjectDiagram',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUmlObjectDiagram'
}

{ #category : 'examples' }
MMM class >> example10 [

	| canvas cells |
	canvas := RSCanvas new.
	cells := (1 to: 6) collect: [ :i |
			         | box label |
			         box := RSBox new
				                size: 40;
				                color: Color veryLightGray;
				                border: (RSBorder new color: Color gray);
				                yourself.
			         label := RSLabel new text: 'text' , i asString.
			         RSComposite new
				         shapes: {
						         box.
						         label };
				         model: i;
				         yourself ].
	canvas addAll: cells.
	RSGridLayout new
		lineItemsCount: 3;
		gapSize: 2;
		on: cells.
	canvas @ RSCanvasController.
	canvas open
]

{ #category : 'examples' }
MMM class >> example11 [

	| canvas cells |
	canvas := RSCanvas new.
	cells := (1 to: 9) collect: [ :i |
			         | label |
			         label := self rs2.
			         
			         RSComposite new
				         shapes: {
						         label };
				         model: i;
				         yourself ].
	canvas addAll: cells.
	RSGridLayout new
		lineItemsCount: 3;
		gapSize: 100;
		on: cells.
	canvas @ RSCanvasController.
	canvas open
]

{ #category : 'examples' }
MMM class >> example12 [

	| canvas cells |
	canvas := RSCanvas new.
	cells := (1 to: 9) collect: [ :i |
			         | label |
			         label := i odd
				                  ifTrue: [
						                  ({ 3. 7 } includes: i)
							                  ifTrue: [ self rs2 ]
							                  ifFalse: [ self rs3 ] ]
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
	canvas @ RSCanvasController.
	canvas open
]

{ #category : 'examples' }
MMM class >> example13 [

	| canvas cells |
	canvas := RSCanvas new.
	cells := (1 to: 9) collect: [ :i |
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
			 cell: 7 rowIndex: 2
			 toCell: 3).
	canvas @ RSCanvasController.
	canvas open
]

{ #category : 'examples' }
MMM class >> example20 [

| canvas pairs pad rowH measure col1W col2W totalW buildCell 
  title cells rowIx object |
canvas := RSCanvas new.
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
title := buildCell value: 'CapitalCity' value: totalW.
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

canvas add: object.
canvas @ RSCanvasController.
canvas open
]

{ #category : 'as yet unclassified' }
MMM class >> linkFromCells: cells cell: fromIx rowIndex: fromRow toCell: toIx [
    | rowH fromRect toRect x1 y1 x2 y2 xOut  |
    rowH := 22.
    fromRect := (cells at: fromIx) encompassingRectangle.
    toRect   := (cells at: toIx)   encompassingRectangle.
 
	(toRect right < fromRect left)
		ifTrue: [ x1 := fromRect left. x2 := toRect right ]
		ifFalse: [ x1 := fromRect right. x2 := toRect left ].
    
    y1 := fromRect top + (rowH * (fromRow + 0.5)).
    y2 := toRect   top + (rowH * 0.5).

	 xOut := (x1 + x2) / 2.	
    
    ^ RSPolyline new
        controlPoints: { x1 @ y1. xOut @ y1. xOut @ y2. x2 @ y2 };
        color: Color black;
        markerEnd: (RSShapeFactory arrow size: 8; color: Color black) asMarker;
        yourself
]

{ #category : 'as yet unclassified' }
MMM class >> old_linkFromCells: cells cell: fromIx rowIndex: fromRow toCell: toIx [
	"Tegner en polylinje fra højre kant af cellen på fromIx (i række fromRow) 
     over til højre kant af cellen på toIx (i titelrækken).
     Række 0 = titel, 1 = første nøgle/værdi-række, osv."

	| rowH fromCell toCell fromRect toRect x1 y1 x2 y2 xOut fromLeftward |
	rowH := 22.
	fromCell := cells at: fromIx.
	toCell := cells at: toIx.
	fromRect := fromCell encompassingRectangle.
	toRect := toCell encompassingRectangle.
	self halt.
	fromLeftward := toRect left < fromRect left.
	x1 := fromRect right.
	y1 := fromRect top + (rowH * (fromRow + 0.5)).
	x2 := toRect right.
	y2 := toRect top + (rowH * 0.5). "titelrækken"
	xOut := (x1 max: x2) + 40.
	^ RSPolyline new
		  controlPoints: {
				  (x1 @ y1).
				  (xOut @ y1).
				  (xOut @ y2).
				  (x2 @ y2) };
		  color: Color black;
		  markerEnd: (RSShapeFactory arrow
				   size: 8;
				   color: Color black) asMarker;
		  yourself
]

{ #category : 'examples' }
MMM class >> rs2: id [

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
MMM class >> rs3: id [

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
