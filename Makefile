# pull in any overrides to IMAGE from the .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

IMAGE?=pdi
APP=spoon
DOCKERFILE?=Dockerfile

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@echo "  help\t\tPrint this help"
	@echo "  test\t\tLookup for docker binary"
	@echo "  setup [DOCKERFILE]\tBuild docker image defined in '\$$DOCKERFILE' (Dockerfile by default)"
	@echo "  run [app]\tRun app defined in '\$$APP' (spoon by default)"
	@echo ""
	@echo "Example: make run APP=spoon"

.PHONY: test
test:
	@which docker
	@which xauth

.PHONY: setup
setup: $(DOCKERFILE)
	docker image build -t $(IMAGE) -f $(DOCKERFILE) .

.PHONY: run
run:
	@echo $(APP)
	docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
	-v $$(pwd):/root/data \
	-e XAUTH=$$(xauth list|grep `uname -n` | cut -d ' ' -f5) -e "DISPLAY" \
       	$(IMAGE) $(APP)
