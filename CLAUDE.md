# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Documentation-only repo: a migration guide for Red Hat OpenShift AI EUS-to-EUS upgrade (2.25.9 to 3.5). No application code, no tests, no linting. All content is Markdown.

## Build Commands

```bash
make build    # Concatenate sections into output/Migrate from OpenShift AI 2.25 to 3.5.md
make clean    # Remove generated output
```

## Architecture

**Source of truth:** 12 numbered Markdown files in `sections/` (01 through 12). Edit only these.

**Generated output:** `output/` directory. Makefile concatenates sections sequentially. Never edit output directly.

Section ordering is strict — filenames `01-` through `12-` determine document order. See `sections/README.md` for the full index with line ranges and content mapping.

## Workflow

1. Edit files in `sections/`
2. Run `make build` to regenerate
3. Commit both section changes and updated output

## Key Context

- Guide covers: Model Serving, Workbenches, TrustyAI, OGX (formerly Llama Stack), AI Pipelines, Ray Training Operator, Kubeflow Training Operator
- Related Jira: RHAISTRAT-1519 (Automated Upgrade Validation), RHAISTRAT-1480 (Automated Migration)
- CLI tool: `rhai-cli` (`registry.redhat.io/rhoai/rhoai-cli-rhel9:v3.5`)
- Largest section: `07-ch2-before-modelserving.md` (Model Serving, ~1039 lines)
