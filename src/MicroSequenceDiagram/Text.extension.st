Extension { #name : 'Text' }

{ #category : '*MicroSequenceDiagram' }
Text >> inspectionRichText: aBuilder [
	<inspectorPresentationOrder: -1 title: 'RichText'>

	^ MicTextPresenter new text: self
]
