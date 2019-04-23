FROM mcr.microsoft.com/azure-functions/node:2.0

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic,
# Hebrew, Thai and a few others).
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update \
  && apt-get install -y wget \
  --no-install-recommends \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get purge --auto-remove -y curl \
  && rm -rf /src/*.deb

# Uncomment to skip the chromium download when installing puppeteer. If you do, you'll need to
# launch puppeteer with:
#     browser.launch({ executablePath: 'google-chrome-unstable' })
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

WORKDIR /home/site/wwwroot

RUN npm install --no-save chrome-launcher@0.10.5 lighthouse@4.3.0 puppeteer@1.14.0
