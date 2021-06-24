FROM klakegg/hugo AS hugo

WORKDIR /src
COPY . .
RUN hugo

FROM nginx
COPY --from=hugo /src/public /usr/share/nginx/html
