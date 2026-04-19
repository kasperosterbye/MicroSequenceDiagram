Extension { #name : 'BlockClosure' }

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sd [
	self sd: ''.
]

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sd: packageName [
	MicroUMLSDForCode new forCode: self inPackage: packageName .
]
