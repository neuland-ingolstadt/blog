FROM klakegg/hugo AS hugo

WORKDIR /src
ENV HUGO_ENV production
COPY . .
RUN hugo

FROM nginx
COPY --from=hugo /src/public /usr/share/nginx/html
