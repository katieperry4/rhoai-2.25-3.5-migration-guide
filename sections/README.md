# Migration Guide Sections

Source: `e2eTesting DRAFT - Migrate from OpenShift AI 2 - Updates.md` (4531 lines)

Split into manageable sections for review and update by agents.

| # | File | Lines | Content |
|---|------|-------|---------|
| 01 | [01-toc-preface.md](01-toc-preface.md) | 1-178 | Table of Contents, Preface |
| 02 | [02-ch1-assess-and-plan.md](02-ch1-assess-and-plan.md) | 179-609 | Ch1: Overview, Prerequisites, rhai-cli deploy, Assessment script, Support submission |
| 03 | [03-ch2-before-certmgr-kueue-registry-featurestore.md](03-ch2-before-certmgr-kueue-registry-featurestore.md) | 610-883 | Ch2: cert-manager (2.1), Kueue (2.2), Model Registry (2.3), Feature Store (2.4) |
| 04 | [04-ch2-before-llamastack.md](04-ch2-before-llamastack.md) | 884-1033 | Ch2: Llama Stack (2.5) |
| 05 | [05-ch2-before-aipipelines-trustyai.md](05-ch2-before-aipipelines-trustyai.md) | 1034-1423 | Ch2: AI Pipelines (2.4), TrustyAI (2.5) including backup/guardrails |
| 06 | [06-ch2-before-workbenches-ray.md](06-ch2-before-workbenches-ray.md) | 1424-1719 | Ch2: Workbenches (2.6), Ray Training (2.7) |
| 07 | [07-ch2-before-modelserving.md](07-ch2-before-modelserving.md) | 1720-2758 | Ch2: Model Serving (2.8) - largest section, 1039 lines |
| 08 | [08-ch2-training-operator-ch3-upgrade.md](08-ch2-training-operator-ch3-upgrade.md) | 2759-2989 | Ch2: Kubeflow Training (2.9), Operator (2.10), Ch3: Upgrade procedure |
| 09 | [09-ch4-after-operator-aihub-featurestore-llama-pipelines.md](09-ch4-after-operator-aihub-featurestore-llama-pipelines.md) | 2990-3334 | Ch4: Operator (4.1), AI Hub (4.2), Feature Store (4.3), Llama Stack (4.4), Pipelines (4.5) |
| 10 | [10-ch4-after-trustyai.md](10-ch4-after-trustyai.md) | 3335-3846 | Ch4: TrustyAI (4.6) - backups, guardrails, restore, GPU deadlock |
| 11 | [11-ch4-after-workbenches-ray-modelserving.md](11-ch4-after-workbenches-ray-modelserving.md) | 3847-4431 | Ch4: Workbenches (4.7), Ray (4.8), Model Serving (4.9) |
| 12 | [12-ch4-after-training-ch5-cleanup-legal.md](12-ch4-after-training-ch5-cleanup-legal.md) | 4432-4531 | Ch4: Kubeflow Training (4.10), Ch5: Cleanup, Legal Notice |
