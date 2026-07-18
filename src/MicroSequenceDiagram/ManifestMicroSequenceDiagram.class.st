"
# MicroSequenceDiagram

`MicroSequenceDiagram` provides a lightweight way to build, render, and explore UML-style sequence diagrams in Pharo. It is intended for interactive use in the Playground, inspectors, examples, and documentation workflows where a compact visualisation of object collaboration is more useful than a full modelling environment.

The package centres on a small set of model objects:

- `MicroUMLSDActor` represents a participant in a sequence diagram.
- `MicroUMLSDMessages` represents calls, returns, and self/internal messages between actors.
- `MicroUMLSDAstBuilder` provides a concise fluent syntax for constructing diagrams.
- `MicroUMLSequenceDiagram` lays out and renders the diagram using Roassal.
- `MicroUMLSDForCode` and its subclasses generate diagrams from live Pharo execution contexts.

## Purpose

The package has two complementary purposes.

First, it offers a compact internal DSL for describing sequence diagrams directly in Smalltalk code. For example, actors can be declared and then connected with call and return messages using operators such as `,`, `&`, `->`, `=>`, and `-->`.

Second, it can derive sequence diagrams from running code. By simulating a block and recording its execution contexts, `MicroUMLSDForCode` analyses message flow between classes and packages, then renders this as an interactive diagram. This makes the package useful for understanding unfamiliar code, documenting examples, and debugging collaborations between objects.

## Typical Usage

A hand-written sequence diagram can be created with the AST builder:

```smalltalk
(MicroUMLSDAstBuilder
    , 'Playground'
    , 'Login System'
    , 'Database'
    & 'Playground' -> 'Login System' => 'login'
    & 'Login System' -> 'Database' => 'verify'
    & 'Database' -> 'Playground' --> 'result')
    renderDiagram
```

A diagram can also be generated from code execution:

```smalltalk
MicroUMLSDForCode
    forBlock: [ Color blue + Color cyan ]
    inScope: 'Colors'
```

or, when the appropriate block extensions are available:

```smalltalk
[ Color blue + Color cyan ] sd: 'Colors'
```

## Design

The implementation deliberately remains small and direct. Actors and messages are plain objects with drawing behaviour. Layout is computed by `MicroUMLSequenceDiagram`, which positions actors horizontally according to label widths and message distances, and positions messages vertically using a fixed message gap. Rendering is delegated to Roassal shapes such as `RSCanvas`, `RSBox`, `RSLabel`, `RSLine`, and `RSPolyline`.

The code-generation side works by collecting execution contexts during simulated execution. These contexts are filtered according to a selected scope:

- a package name, handled by `MicroUMLSDForPackageCode`;
- a package/tag pair, handled by `MicroUMLSDForTagCode`;
- a class, handled by `MicroUMLSDForClassCode`.

Messages are then translated into the same actor/message representation used by manually constructed diagrams.

## Interactivity

Actors and messages may have click actions. When a click action is present, the corresponding label is rendered in red and italic, and clicking it evaluates the associated block. This is used by the code-analysis diagrams to open subdiagrams or inspect related documentation, making the rendered diagrams exploratory rather than purely static.

## Notes and Limitations

`MicroSequenceDiagram` is intended as a micro-tool: it favours convenience, immediacy, and readability over complete UML coverage. It does not attempt to model every sequence-diagram construct. Instead, it focuses on the most common elements needed to understand message flow: participants, calls, returns, self-calls, and scoped runtime interactions.

The package is particularly useful when working live in Pharo, where diagrams can be generated from examples and immediately inspected, refined, or followed into more detailed subdiagrams.
"
Class {
	#name : 'ManifestMicroSequenceDiagram',
	#superclass : 'PackageManifest',
	#category : 'MicroSequenceDiagram-Manifest',
	#package : 'MicroSequenceDiagram',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestMicroSequenceDiagram class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#MicroSequenceDiagram)) #'2026-07-18T08:11:20.001734+02:00') )
]

{ #category : 'code-critics' }
ManifestMicroSequenceDiagram class >> ruleRefersToClassRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#MicroSequenceDiagram)) #'2026-07-07T10:36:24.65221+03:00') )
]

{ #category : 'code-critics' }
ManifestMicroSequenceDiagram class >> ruleThreeElementPointRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#MicroSequenceDiagram)) #'2026-07-07T10:36:16.377115+03:00') )
]
