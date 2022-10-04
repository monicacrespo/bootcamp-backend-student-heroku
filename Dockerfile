FROM node:16-alpine AS base
RUN mkdir -p /usr/app
WORKDIR /usr/app

# Build frontend app
FROM base AS front-build
COPY ./front ./
RUN npm install
RUN npm run build

# Build backend app
FROM base AS back-build
COPY ./back ./
RUN npm install
# To generate the DIST folder
RUN npm run build 

# Release
FROM base AS release
COPY --from=front-build /usr/app/dist ./public
COPY --from=back-build /usr/app/dist ./
COPY ./back/package.json ./
COPY ./back/package-lock.json ./
RUN npm ci --only=production


# Set the port that your container uses
EXPOSE 80

# Set environment variables
ENV PORT=80
ENV STATIC_FILES_PATH=./public
ENV API_MOCK=true
ENV AUTH_SECRET=MY_AUTH_SECRET

# Command run when the container starts
ENTRYPOINT ["node", "index"]
# CMD node dist/index 
# This way you can not change the starting point from outside
