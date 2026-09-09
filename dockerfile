# Estágio 1: Compilação do TypeScript e Instalação de Dependências
FROM node:18-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Estágio 2: Imagem Leve e Segura para Execução em Produção
FROM node:18-alpine AS runner
WORKDIR /usr/src/app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY --from=builder /usr/src/app/dist ./dist
# Práticas de DevSecOps: Execução com Usuário Não-Root
USER node
EXPOSE 3000
CMD ["node", "dist/main.js"]
