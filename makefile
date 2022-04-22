lint:
	terraform fmt --recursive

validate:
	terraform init
	terraform validate
	terraform fmt --recursive

docs:
	terraform-docs -c .terraform-docs.yml .

test_and_cover:
	cd test; go test -v -race -covermode=atomic ./...
