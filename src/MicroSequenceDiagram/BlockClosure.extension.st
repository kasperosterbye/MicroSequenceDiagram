Extension { #name : 'BlockClosure' }

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sd [
	self sdPackage
]

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sd: packageName [
	MicroUMLSDForCode forBlock: self inScope: packageName .
]

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sdClass [
	"MicroUMLSDForCode new forCode: self inPackage: ProtoObject "
	self sd: ProtoObject.
]

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sdPackage [
	self sd: ''.
]

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sdTag [
	"MicroUMLSDForCode new forCode: self inPackage: #() "
	self sd: #('' '')
]
