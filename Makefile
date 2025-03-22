DOCKER_IMAGE=tomwright/mermaid-server:latest
CONTAINER_NAME=mermaid-server

docker-image:
	docker build -t ${DOCKER_IMAGE} .

docker-run:
	docker run -d --name ${CONTAINER_NAME} -p 80:80 ${DOCKER_IMAGE}

docker-stop:
	docker stop ${CONTAINER_NAME} || true

docker-rm:
	make docker-stop
	docker rm ${CONTAINER_NAME} || true

docker-logs:
	docker logs -f ${CONTAINER_NAME}

docker-push:
	docker push ${DOCKER_IMAGE}

# Directories
IN_DIR  = ./in
OUT_DIR = ./out

# The pat for the Mermaid CLI
MERMAIDCLI_PATH=./mermaidcli/node_modules/.bin/mmdc

# Define arguments as separate variables
ARG_MERMAIDCLI = --mermaid=$(MERMAIDCLI_PATH)
ARG_PUPPETCONF = --puppeteer=./mermaidcli/puppeteer-config.json
ARG_INDIR      = --in=$(IN_DIR)
ARG_OUTDIR     = --out=$(OUT_DIR)

# Combine arguments into a single variable (space-separated)
ARGS = $(ARG_MERMAIDCLI) $(ARG_PUPPETCONF) $(ARG_INDIR) $(ARG_OUTDIR)

# Target to create input and output directories
create_in_out:
	mkdir -p $(IN_DIR) $(OUT_DIR)

# Install mermaid-cli using npm
install_mermaidcli:
	npm --prefix mermaidcli install

# Target to run the Go application
run: create_in_out install_mermaidcli
	go run cmd/app/main.go $(ARGS)

