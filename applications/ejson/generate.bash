#!/bin/bash

set -e -E -u -o pipefail || exit 1
test "${#}" -eq 0

cd -- "$( dirname -- "$( readlink -e -- "${0}" )" )"

rm -Rf ./.generated
mkdir ./.generated

cp -T ./repositories/ejson/ejson.app.in ./.generated/ejson.app

gcc -shared -o ./.generated/ejson.so \
		-I ./.generated \
		-I ./repositories/ejson \
		-I ./repositories/ejson/yajl \
		-I "${mosaic_pkg_erlang:-/usr/lib/erlang}/usr/include" \
		-L "${mosaic_pkg_erlang:-/usr/lib/erlang}/usr/lib" \
		${mosaic_CFLAGS:-} ${mosaic_LDFLAGS:-} \
		./repositories/ejson/{ejson.c,encode.c,decode.c} \
		./repositories/ejson/yajl/{yajl.c,yajl_alloc.c,yajl_buf.c,yajl_encode.c,yajl_gen.c,yajl_lex.c,yajl_parser.c} \
		${mosaic_LIBS:-}

exit 0
