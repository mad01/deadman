REPO=deadman
CONTAINER=quay.io/shelman/deadman
VERSION ?= $(shell ./hacks/git-version)
LD_FLAGS="-w -s -extldflags \"-static\" "

$( shell mkdir -p _release )

default: format format-verify build

clean:
	@rm -r _release

test: format-verify
	@echo "----- running tests -----"
	@go test -v -i $(shell go list ./... | grep -v '/vendor/')
	@go test -v $(shell go list ./... | grep -v '/vendor/')

build:
	@echo "----- running release build -----"
	@go build -v -o _release/$(REPO) -ldflags $(LD_FLAGS) 

container:
	@docker build -t $(CONTAINER):$(VERSION) --file Dockerfile .

container-push:
	@docker push $(CONTAINER):$(VERSION)

download:
	@go mod download

setup:
	@go get -u golang.org/x/tools/cmd/goimports

format:
	@echo "----- running gofmt -----"
	@gofmt -w -s *.go
	@echo "----- running goimports -----"
	@goimports -w *.go

format-verify:
	@echo "----- running gofmt verify -----"
	@hacks/verify-gofmt
	@echo "----- running goimports verify -----"
	@hacks/verify-goimports

