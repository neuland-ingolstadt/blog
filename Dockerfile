FROM klakegg/hugo:onbuild AS hugo

FROM nginx
COPY --from=hugo /src/public /usr/share/nginx/html
