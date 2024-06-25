GIT_HOOKPATH_KEY = core.hooksPath

validate: update_git
	pre-commit validate-config

update_git: move_hook
	@echo "Updating git config to use hooks from iOS/.githooks/"
	git config core.hooksPath iOS/.githooks

move_hook: pre-commit_apply
	@echo "Moving pre-commit hook to iOS/.githooks/"
	mv -f ../.git/hooks/pre-commit ./.githooks/pre-commit

pre-commit_apply: install_pre-commit
	@echo "Installing pre-commit hooks at default path"
	@if [ -f ../.git/hooks/pre-commit ]; then \
		echo "pre-commit hook already exists, removing it for new one..."; \
		rm ../.git/hooks/pre-commit; \
	fi

	@if git config --unset $(GIT_HOOKPATH_KEY); then \
		echo "Removed Git config for $(GIT_HOOKPATH_KEY)"; \
	else \
		echo "Git config for $(GIT_HOOKPATH_KEY) was not set or failed to remove"; \
	fi

	pre-commit install -f

install_pre-commit:
	@echo "Installing pre-commit hooks using Homebrew"
	brew install pre-commit
