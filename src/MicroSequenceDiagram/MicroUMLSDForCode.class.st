"
## Purpose
`MicroUMLSDForCode` is a specialised analyser for dynamically generating UML sequence diagrams (SDs) from the runtime execution of Pharo code blocks. It captures the message-passing interactions between objects during block simulation, filtering them to focus exclusively on a nominated package (or all packages if unspecified). This enables developers to visualise live object collaborations, method calls, and returns as interactive sequence diagrams, aiding in debugging, refactoring, and comprehension of complex, dynamic behaviours in object-oriented systems. Instantiate once and invoke `forCode:inPackage:` to trace a block's execution; the result is a fully built `MicroUMLSequenceDiagram` with actors (classes), lifelines, synchronous/asynchronous messages (`=>`/`-->`), and activations.

Use it when reverse-engineering sequence diagrams from **live code execution**—ideal for exploratory analysis of package-internal interactions, such as in experiments, UI flows, or algorithmic traces—rather than static source code parsing. It excels at revealing runtime realities like polymorphic dispatches, block closures, and repeated invocations that static tools might miss.

## Main Collaborators and Dependencies
- **`MicroUMLSDAstBuilder`**: Core dependency for constructing the diagram's abstract syntax tree (AST) via a fluent DSL (`&, ->, =>, -->, @` for actors, arrows, activations, and inline sub-sequences).
- **`MicroUMLSequenceDiagram`**: Consumes the AST builder to render the final interactive UI diagram, complete with titles and presenter comments.
- **Runtime contexts**: Relies on `thisContext runSimulated:contextAtEachStep:` for non-intrusively capturing sender/method/return states during block execution.
- **Package ecosystem**: Tagged under `'MicroUML'`; integrates with `'MicroSequenceDiagram'`, `'AIActions'`, and `'AIAExperiments'` (as per examples). Actors leverage class comments via `AIAPresenter`.

No external tools required; purely Pharo introspection-based.

## Important Invariants and Design Constraints
- **Package scoping**: All actors and messages are strictly filtered to classes in the specified `packageName` (empty string = global scope). Cross-package messages are rendered as package-external boundaries (`O` lifeline).
- **Deduplication and self-exclusion**: Duplicate messages (sender/class/selector) are suppressed unless return states differ; self-messages from `MicroUMLSDForCode` are culled.
- **Actor canonicalisation**: Actors are `OrderedDictionary`-keyed by class name strings; only classes (not instances) appear as lifelines, with comments as hover notes.
- **Message semantics**: Synchronous calls use `=>` (non-return), returns use `-->`; constructors (`new`, `new:`) are ignored; inline sub-sequences spawn child diagrams via `umlSPFor:`.
- **Simulation purity**: Block execution is simulated (no side-effects beyond captured contexts); order-preserving via `OrderedCollection`.
- **Constraints**: Single-threaded; assumes pure message sends (handles loops/blocks); no support for primitives or FFI; package must exist at trace time.

Violating package filters yields empty diagrams; always specify `packageName` for precision.

## Illustrative Usage Examples
### Tracing Package Experiments
```smalltalk
MicroUMLSDForCode new
    forCode: [ Exp1 exp1Method1: 7. 2 timesRepeat: [ Exp2 new exp2Method1: 17 ] ]
    inPackage: 'AIAExperiments'.
```
Generates a diagram showing `Exp1 >> exp1Method1:` self-looping into `Exp2 >> exp2Method1:` (twice), with `Exp1`/`Exp2` actors.

### Visualising Parser Flows
```smalltalk
MicroUMLSDForCode new
    forCode: [ Microdown asRichText: '## Joe' ]
    inPackage: 'Microdown'.
```
Renders the message cascade from `Microdown class >> asRichText:` through parsing collaborators, highlighting async returns.

For sub-sequence drill-down, diagrams embed inline `umlSPFor:` activations.
"
Class {
	#name : 'MicroUMLSDForCode',
	#superclass : 'Object',
	#instVars : [
		'packageName',
		'contextList',
		'actions',
		'messages',
		'astBuilder',
		'lastMethod'
	],
	#category : 'MicroSequenceDiagram-MicroUML',
	#package : 'MicroSequenceDiagram',
	#tag : 'MicroUML'
}

{ #category : 'examples' }
MicroUMLSDForCode class >> example1 [
	<example>
	self new forCode: [ Exp1 exp1Method1: 7. 2 timesRepeat: [ Exp2 new exp2Method1: 17]  ] inPackage: 'AIAExperiments'.
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example1_1 [
	<example>
	self new forCode: [ Exp1 exp1Method1: 3. Exp1 exp1Method1: 7. Exp2 new exp2Method1: 21   ] inPackage: 'AIAExperiments'.
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example2 [
	<example>
	self new forCode: [ Microdown asRichText: '## Joe' ] inPackage: 'Microdown'
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example3 [
	<example>
	self new forCode: [ AIASourceCode forClass: MicroUMLSDForCode  ] inPackage: 'AIActions'
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example4 [
	<example>
	self new forCode: [ Exp3 new exp3Method2 ] inPackage: 'AIActions'
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast10BuildMessageList [
	| messageCandidate |
	contextList doWithIndex: [ :context :index | 
		(self ast12CheckPackageContext: context )
			ifTrue: [ 
				messageCandidate := { context sender methodClass. context method methodClass . 
							 context method selector . context isReturn. {index. contextList }}  .
				(self ast15AddCheck: messageCandidate ) ifTrue: [ messages add: messageCandidate ]
				 ].
		 ].
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast12CheckPackageContext: context [
	| boolean |
	boolean :=
		(self classNameCheck: context sender methodClass ) or: [
		self classNameCheck: context method methodClass  ].
	^ boolean
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast15AddCheck: messageCandidate [ 
	messages reverseDo: [ :trac |
		(messageCandidate first: 3) = (trac first: 3)
			ifTrue: [ ^ messageCandidate fourth ~= trac fourth ].
	 ].
	^true
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast20ActionsFromMessages [
	| me |
	me := self class name.
	messages := messages select: [ :m | m first name ~= me and: [ m second name ~= me ] ].
	messages do: [ :message |
		(self classNameCheck: message first)  ifTrue: [ 
			actions at: message first name asString put: message first ].
		(self classNameCheck: message second) ifTrue: [ 
			actions at: message second name asString put: message second ] ].
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast40Build [
	| sd |
	astBuilder := MicroUMLSDAstBuilder new. 
	self ast43BuildActors.
	self ast46BuildMessages.
	sd := MicroUMLSequenceDiagram from: astBuilder.
	sd uiTitle: (packageName 
		ifEmpty: [ 'All packages' ] 
		ifNotEmpty: ['Package: ', packageName]).
	sd build
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast43BuildActors [
	packageName ~= '' ifTrue: [	astBuilder , 'O' ].
	actions do: [ :actorClass | 
		astBuilder , actorClass name asString @ [ AIAPresenter onComment: actorClass comment]].
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast46BuildMessages [
    messages do: [ :message |
		  ((self classNameCheck: message first) and: [ self classNameCheck: message second ])
            ifTrue: [ self ast48BuildExternalMessage: message ]
            ifFalse: [ self ast47BuildPackageMessage: message ] ]
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast47BuildPackageMessage: message [
	| ignoreList|
	ignoreList := { 'new'. 'new:' } asSet.
	(self classNameCheck: message first)
		ifTrue: [ 
			(ignoreList includes: message third) ifFalse: [
				message fourth ifFalse: [
					astBuilder lastMethod: message fifth.
					astBuilder & message first name => message third 
						@ [ self umlSPFor: message ]] ]]
		ifFalse: [ 
			message fourth
					ifFalse: [ astBuilder & 'O' -> message second name => message third. ]
					ifTrue: [ astBuilder & message second name -> 'O' --> message third ]]
		

]

{ #category : 'internals' }
MicroUMLSDForCode >> ast48BuildExternalMessage: message [
	message first = message second
		ifTrue: [
				message fourth
					ifFalse: [ astBuilder & message first name => message third ] ]
		ifFalse: [
				message fourth
					ifFalse: [ astBuilder & message first name -> message second name => message third ]
					ifTrue: [ astBuilder & message second name -> message first name --> message third ] ].
]

{ #category : 'internals' }
MicroUMLSDForCode >> classNameCheck: aClass [
	packageName ifEmpty: [ ^ true ].
	^ aClass package name  = packageName
	
]

{ #category : 'external' }
MicroUMLSDForCode >> forCode: aBlock [
	self forCode: aBlock inPackage: ''
]

{ #category : 'external' }
MicroUMLSDForCode >> forCode: aBlock inPackage: pName [
	packageName := pName.
	thisContext runSimulated: aBlock  contextAtEachStep: [ :context |
			contextList add: context copy.
			].
	self ast10BuildMessageList.
	self ast20ActionsFromMessages.
	self ast40Build.
]

{ #category : 'internals' }
MicroUMLSDForCode >> forContext: aContextList inPackage: pName [
    packageName := pName.
    contextList := aContextList.
    self ast10BuildMessageList.
    self ast20ActionsFromMessages.
    self ast40Build.
]

{ #category : 'initialization' }
MicroUMLSDForCode >> initialize [ 
	contextList := OrderedCollection new.
	actions := OrderedDictionary new.
	messages := OrderedCollection new.
]

{ #category : 'inline' }
MicroUMLSDForCode >> umlSPFor: message [

	| idx cList subList |
	idx := message fifth first.
	cList := message fifth second.
	subList := cList copyFrom: idx to: cList size.
	self class new 
		forContext: subList 
		inPackage: message second package name
]
