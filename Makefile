PROTOC_GEN_PROTOBUF_TS_BIN="./node_modules/.bin/protoc-gen-ts"
PROTOC_GEN_TS_PROTO_BIN="./node_modules/.bin/protoc-gen-ts_proto"
PROTOC_GEN_TWIRP_BIN="./node_modules/.bin/protoc-gen-twirp_ts"

OUT_DIR="./src/generated"
DIST_DIR="./dist"

.DEFAULT_GOAL := build

build: protobuf-ts format
	npm run build:server && \
	npm run build:client

clean:
	rm -rf $(OUT_DIR)
	mkdir -p $(OUT_DIR)
	rm -rf $(DIST_DIR)
	mkdir -p $(DIST_DIR)

format:
	npm run format

protobuf-ts: clean
	protoc \
	-I ./protos \
	--plugin=protoc-gen-ts=$(PROTOC_GEN_PROTOBUF_TS_BIN) \
	--plugin=protoc-gen-twirp_ts=$(PROTOC_GEN_TWIRP_BIN) \
	--ts_opt=client_none \
	--ts_opt=generate_dependencies \
	--ts_out=$(OUT_DIR) \
	--twirp_ts_opt="gateway" \
	--twirp_ts_opt="index_file" \
	--twirp_ts_opt="openapi_twirp" \
	--twirp_ts_opt="openapi_gateway" \
	--twirp_ts_out=$(OUT_DIR) \
	./protos/*.proto
