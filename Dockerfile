# שלב 1: בנייה
FROM node:20-slim AS builder

# התקנת pnpm ודרישות מערכת לבנייה
RUN npm install -g pnpm
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# העתקת קבצי הגדרות
COPY pnpm-lock.yaml package.json ./

# התקנת תלויות
RUN pnpm install --frozen-lockfile

# העתקת כל שאר הקבצים
COPY . .

# שלב קריטי ב-Scramjet: בניית ה-Rewriter וה-Assets
RUN pnpm run build

# שלב 2: הרצה (כדי שהמכונה תהיה קלה ומהירה)
FROM node:20-slim
RUN npm install -g pnpm
WORKDIR /app

# העתקת רק מה שצריך להרצה מהשלב הקודם
COPY --from=builder /app /app

EXPOSE 8080

# הפעלת השרת (לפי ה-scripts ב-package.json שלך)
CMD ["node", "server.js"]
