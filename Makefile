all: wowza push

wowza:
	@docker build -t shcoder/wowza .
push:
	@docker push shcoder/wowza