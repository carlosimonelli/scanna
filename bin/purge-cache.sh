#!/bin/zsh

curl -X POST "https://api.cloudflare.com/client/v4/zones/f6bafdeec38ea3d4d67c0c073a702aa6/purge_cache" \
	-H "X-Auth-Email: cloudflare@canaro.net" \
	-H "X-Auth-Key: $(<../cf-canaro.key) " \
	-H "Content-Type: application/json" \
	--data '{"purge_everything":true}'