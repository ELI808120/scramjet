# שלב 1: שימוש בדמות Node.js יציבה
FROM node:18-slim

# התקנת תלויות מערכת נחוצות
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# יצירת תיקיית עבודה
WORKDIR /app

# העתקת קבצי הגדרות התלויות
COPY package*.json ./

# התקנת התלויות (כולל שלב הבנייה של Scramjet)
RUN npm install

# העתקת שאר קבצי הפרויקט
COPY . .

# הגדרת משתנה סביבה לפורט (חשוב לשרתי ענן)
ENV PORT=8080
EXPOSE 8080

# הפקודה שמריצה את המנוע האחורי
CMD ["node", "server.js"]
