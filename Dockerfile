# Usa una imagen base de Node.js
FROM node:16-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el archivo package.json y package-lock.json (si existe) al contenedor
COPY package*.json ./

# Instala las dependencias de la aplicación
RUN npm install --production

# Copia el resto del código de la aplicación al contenedor
COPY . .

# Expone el puerto en el que la aplicación escucha
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "index.js"]# Usa una imagen base de Node.js
FROM node:16-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el archivo package.json y package-lock.json (si existe) al contenedor
COPY package*.json ./

# Instala las dependencias de la aplicación
RUN npm install --production

# Copia el resto del código de la aplicación al contenedor
COPY . .

# Expone el puerto en el que la aplicación escucha
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "index.js"]