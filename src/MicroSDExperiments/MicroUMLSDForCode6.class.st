"
# MicroUMLSDForCode

**Purpose**: Dynamically generates UML sequence diagrams from live Pharo code execution, capturing inter-class message flows within specified package, tag, or class scopes. Analyses runtime execution contexts to visualise object interactions as MicroUML sequence diagrams, ideal for exploratory programming, debugging complex interactions, and documenting live code behaviour.

**Role in System**: Acts as a **runtime sequence diagram generator** that intercepts method contexts during block execution, filters messages by scope, builds an AST representation, and renders interactive visualisations. Bridges **live code execution** with **static UML documentation**.

## Main Collaborators & Dependencies

| Collaborator | Role |
|--------------|------|
| `MicroUMLSDAstBuilder` | Constructs sequence diagram AST from analysed messages |
| `MicroUMLSequenceDiagram` | Renders final interactive visualisation |
| `thisContext runSimulated:contextAtEachStep:` | Captures execution contexts during block simulation |
| `OrderedCollection`, `OrderedDictionary` | Store contexts, messages, and scoped actions |

## Key Design Features & Invariants

1. **Scope Filtering**: Messages are filtered by package name, `{package, tag}` array, or specific class
2. **Duplicate Elimination**: `ast15AddCheck:` prevents duplicate messages (same sender→receiver→selector)
3. **Self-Filtering**: Excludes messages involving `MicroUMLSDForCode` itself
4. **Recursive Scope Discovery**: `umlSPFor:` automatically extends analysis to discovered packages/tags
5. **External vs Package Messages**: Distinguishes `=>` (synchronous) vs `-->` (return) arrows

## Usage Patterns

### 1. Package-Scoped Analysis (Recommended)
```smalltalk
""Visualise Color arithmetic within Colors package""
MicroUMLSDForCode new 
    forCode: [ Color blue + Color cyan ] 
    inPackage: 'Colors'.

""Analyse any package - auto-discovers scope""
MicroUMLSDForCode new 
    forCode: [ 'a(b*)c' asRegex ] 
    inPackage: ''.
```

### 2. Block Extensions (Fluent API)
```smalltalk
""Chainable syntax for quick analysis""
[ Microdown asRichText: '## Joe' ] sd: 'Microdown'.

""Class-specific analysis""
[ (2/3) + (4/7) ] sdClass.
```

### 3. Advanced: Custom Context Analysis
```smalltalk
""Analyse pre-captured contexts""
MicroUMLSDForCode new 
    forContext: someContextList 
    inPackage: 'MyPackage'.
```

**When to Use**: 
- ✅ Reverse-engineering unfamiliar library interactions
- ✅ Documenting complex algorithms visually 
- ✅ Debugging message flows in multi-class collaborations
- ✅ Creating executable API documentation

**Limitations**: 
- Only captures **public messages** (method sends)
- Requires packages/tags to exist at analysis time
- Excludes block closures and primitive operations
"
Class {
	#name : 'MicroUMLSDForCode6',
	#superclass : 'Object',
	#instVars : [
		'contextList',
		'actions',
		'messages',
		'astBuilder',
		'lastMethod',
		'scope'
	],
	#category : 'MicroSDExperiments-MicroURLMisc',
	#package : 'MicroSDExperiments',
	#tag : 'MicroURLMisc'
}

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example10 [
	<example>
	self new forBlock: [ (2/3) + (4/7) ] inScope: ''.
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example11 [
	<example>
	[ (2/3) + (4/7) ] sd.
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example12 [
	<example>
	[ (2/3) + (4/7) ] sdClass.
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example20 [
	<example>
	self new forBlock: [ Color blue + Color cyan ] inScope: 'Colors'.
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example21 [
	<example>
	[ Color blue + Color cyan ] sd: 'Colors'.
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example30 [
	<example>
	self new forBlock: [ Microdown asRichText: '## Joe' ] inScope: 'Microdown'
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example31 [
	<example>
	self new forBlock: [ Microdown asRichText: '## Joe' ] inScope: Microdown
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example4 [
	<example>
	self new forBlock: [ 'a(b*)c' asRegex ] inScope: 'Regex-Core'
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example40 [
	<example>
	self new forBlock: [ 'a(b*)c' asRegex ] inScope: 'Regex-Core'
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example41 [
	<example>
	[ 'a(b*)c' asRegex ] sd: 'Regex-Core'
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example42 [
	<example>
	[ 'a(b*)c' asRegex ] sd: RxMatcher 
]

{ #category : 'examples' }
MicroUMLSDForCode6 class >> example43 [
	<example>
	[ 'a(b*)c' asRegex ] sdClass 
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> ast10BuildMessageList [
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
MicroUMLSDForCode6 >> ast12CheckPackageContext: context [
	| boolean |
	
	boolean :=
		(self classNameCheck: context sender methodClass ) or: [
		self classNameCheck: context method methodClass  ].
	^ boolean
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> ast15AddCheck: messageCandidate [ 
	messages reverseDo: [ :trac |
		(messageCandidate first: 3) = (trac first: 3)
			ifTrue: [ ^ messageCandidate fourth ~= trac fourth ].
	 ].
	^true
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> ast20ActionsFromMessages [
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
MicroUMLSDForCode6 >> ast40Build [
	| sd |
	astBuilder := MicroUMLSDAstBuilder new. 
	self ast43BuildActors.
	self ast46BuildMessages.
	sd := MicroUMLSequenceDiagram from: astBuilder.
	sd uiTitle: self ast41Title .
	sd build
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> ast41Title [
	scope isString ifTrue: [ 
		scope ifEmpty: [ ^ 'All packages' ].
		^ 'Package: ', scope ].
	scope isArray ifTrue: [ 
		^ 'Package: ', scope first , ' Tag: ', scope second ] .
	scope isClass ifTrue: [ 
		^ 'Class: ' , scope name].
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> ast43BuildActors [
	scope ~= '' ifTrue: [	astBuilder , 'O' ].
	actions do: [ :actorClass | 
		astBuilder , actorClass name asString @ [ AIAPresenter onComment: actorClass comment]].
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> ast46BuildMessages [
    messages do: [ :message |
		  ((self classNameCheck: message first) and: [ self classNameCheck: message second ])
            ifTrue: [ self ast48BuildExternalMessage: message ]
            ifFalse: [ self ast47BuildPackageMessage: message ] ]
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> ast47BuildPackageMessage: message [
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
MicroUMLSDForCode6 >> ast48BuildExternalMessage: message [
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
MicroUMLSDForCode6 >> classNameCheck: aClass [

	scope isString ifTrue: [ ^ self classNameCheckForString: aClass].
	scope isArray ifTrue: [ ^ self classNameCheckForArray: aClass ].
	scope isClass ifTrue: [ ^ self classNameCheckForClass: aClass ].
	self error: 'Should be a string, {packageName. tagName} or a class'.
	^ aClass package name  = scope
	
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> classNameCheckForArray: aClass [
	scope 
		ifNotEmpty: [ 
			^ (aClass package name  = scope first) and: [ aClass packageTag name = scope second ] ].
	(self emptyPackageTestFor: aClass)
		ifFalse: [ ^ false ]
		ifTrue: [  
			scope := { aClass package name . aClass packageTag name}. 
			^ true]
	
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> classNameCheckForClass: aClass [

	scope ~= ProtoObject ifTrue: [ ^ aClass = scope].
	(self emptyPackageTestFor: aClass)
		ifFalse: [ ^ false ]
		ifTrue: [  
			scope := aClass. 
			^ true]
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> classNameCheckForString: aClass [

	scope 
		ifEmpty: [ ^ true ]
		ifNotEmpty: [  ^  aClass package name  = scope ].
	
	
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> emptyPackageTestFor: aClass [

	| test |
	test := aClass = self class or: [
		        (BlockClosure allSubclasses , { BlockClosure } includes: aClass) or: [
			        aClass = Context or: [ aClass = UndefinedObject ] ] ].
	^ test not
]

{ #category : 'external' }
MicroUMLSDForCode6 >> forBlock: aBlock inScope: sName [
	scope := sName.
	thisContext runSimulated: aBlock  contextAtEachStep: [ :context |
			contextList add: context copy.
			].
	self ast10BuildMessageList.
	self ast20ActionsFromMessages.
	self ast40Build.
]

{ #category : 'external' }
MicroUMLSDForCode6 >> forCode: aBlock [
	self forBlock: aBlock inScope: ''
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> forContext: aContextList inScope: sName [
    scope := sName.
    contextList := aContextList.
    self ast10BuildMessageList.
    self ast20ActionsFromMessages.
    self ast40Build.
]

{ #category : 'initialization' }
MicroUMLSDForCode6 >> initialize [ 
	contextList := OrderedCollection new.
	actions := OrderedDictionary new.
	messages := OrderedCollection new.
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> umlSPFor: message [
	"Recursively analyses subsequent message flows within the same package or class scope, extending the sequence diagram to show deeper interactions."
	| idx cList subList nextPackage |
	idx := message fifth first.
	cList := message fifth second.
	subList := cList copyFrom: idx to: cList size.
	scope isString ifTrue: [ nextPackage := message second package name ].
	scope isArray ifTrue: [ 
		nextPackage := { message second package name. message second packageTag name }] .
	scope isClass ifTrue: [
		nextPackage :=message second.].
	self class new 
		forContext: subList 
		inScope: nextPackage
]

{ #category : 'internals' }
MicroUMLSDForCode6 >> xxx_umlSPFor: message [
	| idx cList subList nextPackage |
	idx := message fifth first.
	cList := message fifth second.
	subList := cList copyFrom: idx to: cList size.
	scope isString ifTrue: [ nextPackage := message second package name ].
	scope isArray ifTrue: [ 
		nextPackage := { message second package name. message second packageTag name }] .
	scope isClass ifTrue: [
		nextPackage :=message second.].
	self class new 
		forContext: subList 
		inScope: nextPackage
]
