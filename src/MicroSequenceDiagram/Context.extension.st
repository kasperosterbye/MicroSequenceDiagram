Extension { #name : 'Context' }

{ #category : '*MicroSequenceDiagram' }
Context >> isReturn [
	^ (InstructionStream on: method pc: pc) willReturn
]
