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
	#name : 'MicroUMLSDForCode',
	#superclass : 'Object',
	#instVars : [
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
MicroUMLSDForCode class >> example10 [
	<example>
	self forCode: [ (2/3) + (4/7) ] inScope: ''.
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example11 [
	<example>
	[ (2/3) + (4/7) ] sd.
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example12 [
	<example>
	[ (2/3) + (4/7) ] sdClass.
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example20 [
	<example>
	self forCode: [ Color blue + Color cyan ] inScope: 'Colors'.
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example21 [
	<example>
	[ Color blue + Color cyan ] sd: 'Colors'.
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example30 [
	<example>
	self forCode: [ Microdown asRichText: '## Joe' ] inScope: 'Microdown'
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example31 [
	<example>
	self forCode: [ Microdown asRichText: '## Joe' ] inScope: Microdown
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example4 [
	<example>
	self forCode: [ 'a(b*)c' asRegex ] inScope: 'Regex-Core'
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example40 [
	<example>
	self forCode: [ 'a(b*)c' asRegex ] inScope: 'Regex-Core'
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example41 [
	<example>
	[ 'a(b*)c' asRegex ] sd: 'Regex-Core'
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example42 [
	<example>
	[ 'a(b*)c' asRegex ] sd: RxMatcher 
]

{ #category : 'examples' }
MicroUMLSDForCode class >> example43 [
	<example>
	[ 'a(b*)c' asRegex ] sdClass 
]

{ #category : 'external' }
MicroUMLSDForCode class >> forCode: aBlock inScope: sName [
	| subClass |
	subClass := nil. 
	sName isString ifTrue: [ subClass := MicroUMLSDForPackageCode new].
	sName isArray ifTrue: [ subClass := MicroUMLSDForTagCode new ].
	sName isClass ifTrue: [ subClass := MicroUMLSDForClassCode new ].
	subClass scope: sName.
	subClass forCode: aBlock
]

{ #category : 'internals' }
MicroUMLSDForCode class >> forContext: aContextList inScope: sName [
	| subClass |
	subClass := nil. 
	sName isString ifTrue: [ subClass := MicroUMLSDForPackageCode new].
	sName isArray ifTrue: [ subClass := MicroUMLSDForTagCode new ].
	sName isClass ifTrue: [ subClass := MicroUMLSDForClassCode new ].
	subClass scope: sName.
   subClass forContext: aContextList
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
	sd uiTitle: self ast41Title .
	sd build
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast41Title [
	self subclassResponsibility 
]

{ #category : 'internals' }
MicroUMLSDForCode >> ast43BuildActors [
	self subclassResponsibility 
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

	self subclassResponsibility.
	
]

{ #category : 'internals' }
MicroUMLSDForCode >> emptyPackageTestFor: aClass [

	| test |
	test := aClass = self class or: [
		        (BlockClosure allSubclasses , { BlockClosure } includes: aClass) or: [
			        aClass = Context or: [ aClass = UndefinedObject ] ] ].
	^ test not
]

{ #category : 'external' }
MicroUMLSDForCode >> forCode: aBlock [
	thisContext runSimulated: aBlock  contextAtEachStep: [ :context |
			contextList add: context copy.
			].
	self ast10BuildMessageList.
	self ast20ActionsFromMessages.
	self ast40Build.
]

{ #category : 'external' }
MicroUMLSDForCode >> forCode: aBlock inScope: sName [
	thisContext runSimulated: aBlock  contextAtEachStep: [ :context |
			contextList add: context copy.
			].
	self ast10BuildMessageList.
	self ast20ActionsFromMessages.
	self ast40Build.
]

{ #category : 'internals' }
MicroUMLSDForCode >> forContext: aContextList [
    contextList := aContextList.
    self ast10BuildMessageList.
    self ast20ActionsFromMessages.
    self ast40Build.
]

{ #category : 'internals' }
MicroUMLSDForCode >> forContext: aContextList inScope: sName [
	self halt.
    "scope := sName.
    contextList := aContextList.
    self ast10BuildMessageList.
    self ast20ActionsFromMessages.
    self ast40Build."
]

{ #category : 'initialization' }
MicroUMLSDForCode >> initialize [ 
	contextList := OrderedCollection new.
	actions := OrderedDictionary new.
	messages := OrderedCollection new.
]

{ #category : 'accessing' }
MicroUMLSDForCode >> scope: scope [
	self subclassResponsibility 
]

{ #category : 'internals' }
MicroUMLSDForCode >> umlSPFor: message [
	self subclassResponsibility 
]
