OUTPUT_DIR := output
OUTPUT_FILE := $(OUTPUT_DIR)/Migrate from OpenShift AI 2.25 to 3.5.md
STAGING_DIR := staging
SITE_DIR := site

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

STAGED_SECTIONS := $(patsubst sections/%,$(STAGING_DIR)/%,$(SECTIONS))

.PHONY: build build-offline resolve-digests inject-images html clean

ifdef SKIP_DIGESTS
build: inject-images
else
build: resolve-digests inject-images
endif

build-offline: inject-images

resolve-digests:
	@./scripts/resolve-digests.sh

inject-images: $(SECTIONS) images.env image-placeholders.conf | $(OUTPUT_DIR) $(STAGING_DIR)
	@cp $(SECTIONS) $(STAGING_DIR)/
	@while IFS= read -r line; do \
		case "$$line" in \#*|"") continue;; esac; \
		key=$$(echo "$$line" | awk '{print $$1}'); \
		placeholder=$$(echo "$$line" | awk '{print $$2}'); \
		value=$$(grep "^$$key=" images.env | cut -d= -f2-); \
		if [ -n "$$value" ]; then \
			for f in $(STAGING_DIR)/*.md; do \
				sed "s|$$placeholder|$$value|g" "$$f" > "$$f.tmp" && mv "$$f.tmp" "$$f"; \
			done; \
		fi; \
	done < image-placeholders.conf
	@cat $(STAGED_SECTIONS) > "$(OUTPUT_FILE)"
	@echo "Built: $(OUTPUT_FILE) ($$(wc -l < "$(OUTPUT_FILE)") lines)"

html: build
	@./scripts/render-html.sh "$(OUTPUT_FILE)" "$(SITE_DIR)"

images.env:
	@echo "ERROR: images.env not found. Run 'make resolve-digests' first or 'make build' for full build." >&2
	@exit 1

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

$(STAGING_DIR):
	mkdir -p $(STAGING_DIR)

clean:
	rm -f "$(OUTPUT_FILE)"
	rm -rf $(STAGING_DIR)
	rm -rf $(SITE_DIR)
	rm -f images.env
