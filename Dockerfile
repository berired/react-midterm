FROM node:lts-alpine AS builder
WORKDIR /app
# Copy dependency files first to support layer caching.
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm test
RUN npm run build

FROM nginx:stable-alpine AS production
COPY --from=builder /app/dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
