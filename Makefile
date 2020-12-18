poly:
	poly --script lexer.sml

mlkit:
	mlkit lexer.mlb

mlton:
	mlton -default-ann 'warnUnused true' lexer.mlb

.PHONY: poly mlkit mlton
