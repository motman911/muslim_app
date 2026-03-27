# Quran Feature

This feature follows clean architecture with three layers:

- domain: entities, repository contract, and usecase.
- data: local datasource and repository implementation.
- presentation: Riverpod providers, pages, and widgets.

Current scope:

- Load surahs offline from assets.
- Search by surah number, Arabic name, or English name.
- Ready to plug remote Quran API with minimal changes.
