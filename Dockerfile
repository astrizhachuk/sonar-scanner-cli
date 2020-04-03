FROM adoptopenjdk:14-hotspot

LABEL author.name="Alexander Strizhachuk"
LABEL author.email="strizhhh@mail.ru"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        git \
        openssh-client \
        unzip \
    && rm -rf  \
        /var/lib/apt/lists/* \
        /var/cache/debconf

ENV TZ=Europe/Moscow \
    SONAR_SCANNER_VERSION="4.3.0.2102" \
    SONAR_SCANNER_HOME=/usr/lib/sonar-scanner
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /usr/src

RUN curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
	unzip sonarscanner.zip && \
	rm sonarscanner.zip && \
	mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux /usr/lib/sonar-scanner && \
	ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner

#   ensure Sonar uses the provided Java instead of a embedded one
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/lib/sonar-scanner/bin/sonar-scanner

ENTRYPOINT ["sonar-scanner"] 
