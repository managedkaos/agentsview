.PHONY: help all

PORT ?= 8080
URL ?= http://localhost:$(PORT) ## URL to access AgentsView

help: ## Display available targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "\033[36m%-28s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Run AgentsView locally on the defined port
	docker run --detach --rm --publish 127.0.0.1:$(PORT):8080 \
		-v agentsview-data:/data \
		-v "$(HOME)/.claude/projects:/agents/claude:ro" \
		-v "$(HOME)/.codex/sessions:/agents/codex:ro" \
		-v "$(HOME)/.cursor/projects:/agents/cursor:ro" \
		-e CLAUDE_PROJECTS_DIR=/agents/claude \
		-e CODEX_SESSIONS_DIR=/agents/codex \
		-e CURSOR_PROJECTS_DIR=/agents/cursor \
		ghcr.io/kenn-io/agentsview:latest
	@echo $(URL)
	@open $(URL)

down: ## Stop AgentsView if running
	-docker stop $(shell docker ps -q --filter ancestor=ghcr.io/kenn-io/agentsview:latest)
