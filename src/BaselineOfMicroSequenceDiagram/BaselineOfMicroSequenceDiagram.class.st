Class {
	#name : 'BaselineOfMicroSequenceDiagram',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMicroSequenceDiagram',
	#package : 'BaselineOfMicroSequenceDiagram'
}

{ #category : 'baselines' }
BaselineOfMicroSequenceDiagram >> baseline: spec [
    <baseline>
    spec for: #common do: [
        spec package: 'MicroSequenceDiagram'.
        spec package: 'MicroSDExperiments'.
        
        spec group: 'default' with: #('MicroSequenceDiagram').
        spec group: 'all' with: #('MicroSequenceDiagram' 'MicroSDExperiments') ]
]
