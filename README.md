# RHOAI 2.25 to 3.5 Migration Guide

Migration guide for Red Hat OpenShift AI EUS-to-EUS upgrade (2.25.9 to 3.5).

This guide provides step-by-step instructions for cluster administrators performing an in-place or side-by-side migration from OpenShift AI 2.25.9 (and later) to 3.5, covering all components: Model Serving, Workbenches, TrustyAI, OGX (formerly Llama Stack), AI Pipelines, Ray Training Operator, and Kubeflow Training Operator.

## Directory structure

```
sections/           12 markdown files, one per chapter/topic (edit here)
output/             Generated concatenated document (do not edit directly)
Makefile            Concatenates sections into the final document
```

See [sections/README.md](sections/README.md) for the full section index.

## Build the document

```bash
make build
```

This concatenates all section files in order and writes the output to:

```
output/Migrate from OpenShift AI 2.25 to 3.5.md
```

To remove the generated output:

```bash
make clean
```

## Contributing

1. Edit files in `sections/` (not the generated output).
2. Run `make build` to regenerate the concatenated document.
3. Review the output in `output/`.
4. Commit both the section changes and the updated output.

Section files are numbered `01-` through `12-` and must be kept in order. The Makefile concatenates them sequentially to produce the final document.

## Related

- **RHAISTRAT-1519** - Automated Upgrade Validation feature
- **RHAISTRAT-1480** - Automated Migration: RHOAI 2.25 to 3.5 (EUS) outcome
- **rhai-cli** - Migration assessment and action CLI (`registry.redhat.io/rhoai/rhai-cli-rhel9:v3.5`)
