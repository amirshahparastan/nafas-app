# Nafas Design System v1.1

## جهت بصری
**Expressive Minimalism + Subtle Depth**

پایه طراحی مینیمال و خلوت است؛ عمق با gradient، shadow، elevation و motion محدود اضافه می‌شود. 3D سنگین، neumorphism افراطی و glass شلوغ استفاده نمی‌شود.

## Tokens
- Primary `#0F6F5C`
- Deep `#0B4F43`
- Dark `#083B34`
- Success `#24B58A`
- Accent `#FF7A59`
- Background `#F2F8F5`
- Surface `#FFFFFF`
- Text `#173A35`

## Button hierarchy
1. **Primary**: سبز، فقط برای ادامه/ثبت اصلی
2. **Secondary**: سفید با متن تیره/سبز و border ظریف — حالت پیش‌فرض اکثر Actionها
3. **Urgent Accent**: نارنجی فقط برای «هوس کردم» و Action فوری
4. **Danger**: فقط برای حذف/Reset/Report نهایی

## RTL
- Back arrow روی سمت راست و رو به راست
- Disclosure chevron در انتهای Row و متناسب با مسیر ورود به صفحه
- عنوان AppBar راست‌چین
- عدد، نمودار و progress مستقل از جهت متن بررسی شوند

## Radius
Chip 14–16 / Input 16 / Button 20 / Card 24 / Hero 28–30

## Spacing
4 / 8 / 12 / 16 / 20 / 24 / 32؛ حاشیه صفحه 18px

## Typography
Hierarchy مهم‌تر از صرفاً انتخاب فونت است: وزن، line-height، اندازه و فاصله باید ثابت باشد. Production target: Vazirmatn یا Estedad با مجوز مناسب. Build آفلاین از fallback استفاده می‌کند.
