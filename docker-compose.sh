# https://www.berthon.eu/2017/getting-docker-compose-on-raspberry-pi-arm-the-easy-way/
function docker_compose_install {
	echo "Installing Docker Compose..."

	git clone https://github.com/docker/compose.git

	cd compose
	cp Dockerfile Dockerfile.armhf
	sed -i -e 's/^FROM debian\:/FROM armhf\/debian:/' Dockerfile.armhf
	sed -i -e 's/x86_64/armel/g' Dockerfile.armhf

	docker build -t docker-compose:armhf -f Dockerfile.armhf .
	docker run --rm --entrypoint="script/build/linux-entrypoint" -v $(pwd)/dist:/code/dist -v $(pwd)/.git:/code/.git "docker-compose:armhf"

	cp dist/docker-compose-Linux-armv7l /usr/local/bin/docker-compose
	chown root:root /usr/local/bin/docker-compose
	chmod 0755 /usr/local/bin/docker-compose
	docker-compose version
}