Extension { #name : 'BlockClosure' }

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sd [
	self sdPackage
]

{ #category : '*MicroSequenceDiagram' }
BlockClosure >> sd: packageName [
	MicroUMLSDForCode new forCode: self inScope: packageName .
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
BlockClosure >> sdTab [
	"MicroUMLSDForCode new forCode: self inPackage: #() "
	self sd: #()
]
