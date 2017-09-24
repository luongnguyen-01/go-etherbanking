# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gebc android ios gebc-cross swarm evm all test clean
.PHONY: gebc-linux gebc-linux-386 gebc-linux-amd64 gebc-linux-mips64 gebc-linux-mips64le
.PHONY: gebc-linux-arm gebc-linux-arm-5 gebc-linux-arm-6 gebc-linux-arm-7 gebc-linux-arm64
.PHONY: gebc-darwin gebc-darwin-386 gebc-darwin-amd64
.PHONY: gebc-windows gebc-windows-386 gebc-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gebc:
	build/env.sh go run build/ci.go install ./cmd/gebc
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gebc\" to launch gebc."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gebc.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gebc.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

gebc-cross: gebc-linux gebc-darwin gebc-windows gebc-android gebc-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gebc-*

gebc-linux: gebc-linux-386 gebc-linux-amd64 gebc-linux-arm gebc-linux-mips64 gebc-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-*

gebc-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gebc
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep 386

gebc-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gebc
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep amd64

gebc-linux-arm: gebc-linux-arm-5 gebc-linux-arm-6 gebc-linux-arm-7 gebc-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep arm

gebc-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gebc
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep arm-5

gebc-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gebc
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep arm-6

gebc-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gebc
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep arm-7

gebc-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gebc
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep arm64

gebc-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gebc
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep mips

gebc-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gebc
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep mipsle

gebc-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gebc
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep mips64

gebc-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gebc
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gebc-linux-* | grep mips64le

gebc-darwin: gebc-darwin-386 gebc-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gebc-darwin-*

gebc-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gebc
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-darwin-* | grep 386

gebc-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gebc
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-darwin-* | grep amd64

gebc-windows: gebc-windows-386 gebc-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gebc-windows-*

gebc-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gebc
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-windows-* | grep 386

gebc-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gebc
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gebc-windows-* | grep amd64
