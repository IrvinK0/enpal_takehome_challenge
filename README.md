# Description

A new Enpal Flutter test project.

The project is organized as follows:

1. **Data Source** is inside the [packages] folder and there are two packages: [caching] and [api_client]
    
- **[api_client]** consists of an interface and an actual implementation of data fetching with [http.Client] along with unit tests.
- **[caching]** consists of an interface and an actual implementation of data caching with [SharedPreferences] along with unit tests.

2. **Domain (Business) Logic and Presentation Logic** are inside the main [lib] folder:

- **[MonitoringRepository]** handles the logic of working with remote and local data.
- The **[bloc]** library is used for state management.
- Flutter widgets and pages are inside the [presentation] folder.
- There are additional core files with Colors, Themes, Constants, and various helpers.

3. **Tests**:
- Core business logic is covered with unit tests.
- UI components and interactions are tested with widget tests.

## Getting Started

The app can be run using the following command from the project root folder:

```bash
flutter run lib/main.dart
