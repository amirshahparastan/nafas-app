# Architecture Direction

## Flutter
Feature-based structure:
- core/theme
- core/state
- core/widgets
- features/onboarding
- features/home
- features/craving
- features/health
- features/community
- features/goal
- features/stats

## Current build
ChangeNotifier + InheritedNotifier برای کاهش dependency و اجرای آفلاین.

## Production evolution
- Repository interfaces
- LocalDataSource
- RemoteDataSource برای Community
- persistence package پس از پایدار شدن اینترنت
- service layer برای notification
- DTO/domain separation در فاز backend

اصل: Core quitting باید حتی با قطع اینترنت کار کند؛ Community gracefully degrade شود.
