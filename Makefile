all:
	ruby -c Entry.rb
    ruby -c Entry_Validator_spec.rb
    ruby -c Entry_spec.rb
    ruby -c EntryValidator.rb
	ruby -c main.rb

test:
	rspec spec

rdoc:
	rm -r doc
	rdoc