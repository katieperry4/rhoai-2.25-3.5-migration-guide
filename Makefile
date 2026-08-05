OUTPUT_DIR := output
OUTPUT_FILE := $(OUTPUT_DIR)/Migrate from OpenShift AI 2.25 to 3.5.md

SECTIONS := \
	sections/01-toc-preface.md \
	sections/02-ch1-assess-and-plan.md \
	sections/03-ch2-before-certmgr-kueue-registry-featurestore.md \
	sections/04-ch2-before-llamastack.md \
	sections/05-ch2-before-aipipelines-trustyai.md \
	sections/06-ch2-before-workbenches-ray.md \
	sections/07-ch2-before-modelserving.md \
	sections/08-ch2-training-operator-ch3-upgrade.md \
	sections/09-ch4-after-operator-aihub-featurestore-llama-pipelines.md \
	sections/10-ch4-after-trustyai.md \
	sections/11-ch4-after-workbenches-ray-modelserving.md \
	sections/12-ch4-after-training-ch5-cleanup-legal.md

.PHONY: build clean

build: $(SECTIONS) | $(OUTPUT_DIR)
	cat $(SECTIONS) > "$(OUTPUT_FILE)"
	@echo "Built: $(OUTPUT_FILE) ($$(wc -l < "$(OUTPUT_FILE)") lines)"

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

clean:
	rm -f "$(OUTPUT_FILE)"
